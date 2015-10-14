class ResultsController < ApplicationController

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    def find_center(tweets)
      ave_lat = 0
      ave_lng = 0
      @tweets.each do |t|
          ave_lat += t.geo.coordinates[0]
          ave_lng += t.geo.coordinates[1]
      end
      [(ave_lat / @tweets.length), (ave_lng / @tweets.length)]
    end

    if params[:search].present?
      query = params[:search]
      @tweets = client.search("##{query}&geocode:39.5,-98.35,1500mi").take(25).delete_if { |t| t.place.class == Twitter::NullObject }
      @center = find_center(@tweets)
      @zoom_level = 4

      if current_user
        Search.create(
          query: params[:search],
          trend_or_location: "Trend",
          user: current_user
          )
      end

    elsif params[:local].present?
      ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
      ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
      location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
      q = "geocode:#{location.latitude},#{location.longitude},10mi"
      @tweets = client.search(q).take(25).delete_if { |t| t.place.class == Twitter::NullObject }
      @center = find_center(@tweets)
      @zoom_level = 13


      if current_user
        Search.create(
          query: location.real_region_name,
          trend_or_location: "Location",
          user: current_user
          )
      end

    elsif params[:location].present?
      location = params[:location]
      query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV["GOOGLE_GEOCODING"]}")
      top_result = query.first[1].first
      lat = top_result["geometry"]["location"]["lat"]
      lng = top_result["geometry"]["location"]["lng"]
      q = "geocode:#{lat},#{lng},5mi"
      @tweets = client.search(q).take(25).delete_if { |t| t.place.class == Twitter::NullObject }
      @center = find_center(@tweets)
      @zoom_level = 13

      place_name = top_result["address_components"].first["long_name"]
      if current_user
        Search.create(
          query: place_name,
          trend_or_location: "Location",
          user: current_user
          )
      end

    end

    respond_to do |format|
      format.html
      format.json { render json: [@tweets, @center, @zoom_level] }
    end

  end

end
