class HomesController < ApplicationController
  def index
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
    q = "geocode:39.5,-98.35,1500mi"
    all_tweets = client.search(q).take(50)
    @tweets = all_tweets.delete_if {|t| /(#|)(job|hiring|work)/i.match(t.text)}
    raw = []
    @tweets.each do |t|
      words = t.text.split
      words.each do |w|
        raw << w
      end
    end
    @local_trends = raw.find_all { |e| raw.count(e) > 2 && e.length > 3 }.uniq!
    # binding.pry

    #
    def consumer_key
      OAuth::Consumer.new(
      ENV["TWITTER_CONSUMER_KEY"],
      ENV["TWITTER_CONSUMER_SECRET"])
    end

    def access_token
      OAuth::Token.new(
      ENV["TWITTER_ACCESS_TOKEN"],
      ENV["TWITTER_ACCESS_SECRET"])
    end
    consumer_key
    access_token
    # address = URI("https://api.twitter.com/1.1/trends/place.json?id=23424977")
    address = URI("https://api.twitter.com/1.1/trends/available.json")
    request = Net::HTTP::Get.new address.request_uri
    http = Net::HTTP.new address.host, address.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request
    info = nil
    if response.code == '200' then
      info = JSON.parse(response.body)
      us_trends = info.select { |i| i["countryCode"] == "US" }[0..5]
    end
    trend_locations = []
    us_trends.each do |trend|
      trend_locations << trend["woeid"]
    end
    us_trend_markers = Hash.new {|h, k| h[k] = ''}
    trend_locations.each do |place|
      address = URI("https://api.twitter.com/1.1/trends/place.json?id=#{place}")
      request = Net::HTTP::Get.new address.request_uri
      http = Net::HTTP.new address.host, address.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      request.oauth! http, consumer_key, access_token
      http.start
      response = http.request request
      info = nil
      if response.code == '200' then
        trend_response = JSON.parse(response.body)
        # binding.pry
      end
      trend_name = trend_response.first["trends"][0]["name"].to_sym
      us_trend_markers.store(trend_name, place)
    end

    # @remote_trends = []
    # info[0]["trends"].each do |trend|
    #   @remote_trends << trend.first[1]
    # end

  end
end
