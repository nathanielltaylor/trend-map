class ResultsController < ApplicationController

  # class TemporaryTweet
  #   attr_reader :author, :text, :lat, :lng, :has_location, :location
  #   def initialize(author, text, lat, lng, has_location, location = nil)
  #     author = author
  #     @text = text
  #     @lat = lat
  #     @lng = lng
  #     @has_location = has_location
  #     @location = location
  #   end
  # end

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    if params[:search].present?
      query = params[:search]
      @tweets = client.search("##{query}").take(25)

      if current_user
        Search.create(
          query: params[:search],
          trend_or_location: "Trend",
          user: current_user
          )
      end

      # respond_to do |format|
      #   format.html
      #   format.json { render json: @tweets }
      # end

    elsif params[:local].present?
      ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
      ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
      location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
      q = "geocode:#{location.latitude},#{location.longitude},1mi"
      all_tweets = client.search(q).take(25).delete_if { |t| t.place.class == Twitter::NullObject }

      # TweetAssembler.create_json(all_tweets)
      @tweets = all_tweets
      ave_lat = 0
      ave_lng = 0
      all_tweets.each do |t|
          ave_lat += t.geo.coordinates[0]
          ave_lng += t.geo.coordinates[1]
      end
      @center = [(ave_lat / all_tweets.length), (ave_lng / all_tweets.length)]


      if current_user
        Search.create(
          query: location.real_region_name,
          trend_or_location: "Location",
          user: current_user
          )
      end

      # binding.pry

      # respond_to do |format|
      #   format.html
      #   format.json { render json: @tweets }
      # end

    elsif params[:location]
      location = params[:location]
      query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV["GOOGLE_GEOCODING"]}")
      top_result = query.first[1].first
      lat = top_result["geometry"]["location"]["lat"]
      lng = top_result["geometry"]["location"]["lng"]
      q = "geocode:#{lat},#{lng},5mi"
      @tweets = client.search(q).take(25).delete_if { |t| t.place.class == Twitter::NullObject }
      ave_lat = 0
      ave_lng = 0
      @tweets.each do |t|
          ave_lat += t.geo.coordinates[0]
          ave_lng += t.geo.coordinates[1]
      end
      @center = [(ave_lat / @tweets.length), (ave_lng / @tweets.length)]

      place_name = top_result["address_components"].first["long_name"]
      if current_user
        Search.create(
          query: place_name,
          trend_or_location: "Location",
          user: current_user
          )
      end

      # respond_to do |format|
      #   format.html
      #   format.json { render json: @tweets }
      # end
    end

    respond_to do |format|
      format.html
      format.json { render json: [@tweets, @center] }
    end

  end

end


# class TweetAssembler
#   def self.create_json(tweets)
#     ...
#     ...
#     ...
#     ...
#   end
# end
