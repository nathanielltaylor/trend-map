class HomesController < ApplicationController
  def index
    def consumer_key
      OAuth::Consumer.new(
        ENV["TWITTER_CONSUMER_KEY"],
        ENV["TWITTER_CONSUMER_SECRET"]
      )
    end

    def access_token
      OAuth::Token.new(
        ENV["TWITTER_ACCESS_TOKEN"],
        ENV["TWITTER_ACCESS_SECRET"]
      )
    end

    def api_get(url)
      address = URI(url)
      request = Net::HTTP::Get.new address.request_uri
      http = Net::HTTP.new address.host, address.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      request.oauth! http, consumer_key, access_token
      http.start
      response = http.request request
      response
    end

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
    ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
    location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
    @lat = location.latitude
    @lng = location.longitude

    sample_tweet = Tweet.first
    if sample_tweet.nil? || (!sample_tweet.nil? && ((sample_tweet.created_at + 3.minutes) < DateTime.now.utc))
      q = "geocode:39.5,-98.35,1500mi"
      all_tweets = client.search(q).take(50)
      if !all_tweets.nil?
        all_tweets.delete_if { |t| /(#|)(job|hiring|work)/i.match(t.text) }
        all_tweets.delete_if { |t| t.place.class == Twitter::NullObject }
        Tweet.destroy_all
        all_tweets.each do |tweet|
          Tweet.create(
            text: tweet.text,
            latitude: tweet.geo.coordinates[0],
            longitude: tweet.geo.coordinates[1]
          )
        end
      end
    end

    @tweets = Tweet.all

    raw = []
    @local_trends = []
    @tweets.each do |t|
      words = t.text.split
      words.each { |w| raw << w }
    end
    common_words = raw.select { |e| raw.count(e) > 2 && e.length > 3 }.uniq!
    if !common_words.nil?
      common_words.delete_if do |w|
        /(have|this|with|just|your|when|&amp;|from|that|-&gt;|were)/i.match(w)
      end
      @local_trends = common_words
    end

    sample_trend = Trend.first
    if sample_trend.nil? || (!sample_trend.nil? && ((sample_trend.created_at + 20.minutes) < DateTime.now.utc))

      trend_locations = []
      available_trends_response = api_get("https://api.twitter.com/1.1/trends/available.json")
      if available_trends_response.code == '200'
        available_trends_info = JSON.parse(available_trends_response.body)
        us_trends = available_trends_info.select { |i| i["countryCode"] == "US" }[0..5]
        us_trends.each do |trend|
          trend_locations << trend["woeid"]
        end
      end

      us_trend_markers = Hash.new { |h, k| h[k] = '' }
      trend_locations.each do |place|
        trend_location_response = api_get("https://api.twitter.com/1.1/trends/place.json?id=#{place}")
        if trend_location_response.code == '200'
          trend_location_info = JSON.parse(trend_location_response.body)
          trend_name = trend_location_info.first["trends"][0]["name"]
          us_trend_markers.store(trend_name, place)
          Trend.destroy_all
        end
      end

      us_trend_markers.each do |trend, place|
        location = HTTParty.get("http://where.yahooapis.com/v1/place/#{place}?format=json&appid=#{ENV["YAHOO"]}")
        lat = location["place"]["centroid"]["latitude"]
        lng = location["place"]["centroid"]["longitude"]
        Trend.create(name: trend, latitude: lat, longitude: lng)
      end
    end

    @remote_trends = Trend.all

    respond_to do |format|
      format.html
      format.json { render json: [@lat, @lng, @tweets, @remote_trends] }
    end
  end
end
