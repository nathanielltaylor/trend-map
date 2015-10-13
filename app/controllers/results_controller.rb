class ResultsController < ApplicationController
  def index
    def check_previous(new_search)
      previous = current_user.searches.all
      previous.each do |s|
        if s.query == new_search
          return false
        end
        true
      end
    end

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    if params[:search]
      query = params[:search]
      @tweets = client.search("##{query}").take(25)

      if current_user && check_previous(params[:search])
        Search.create(
          query: params[:search],
          trend_or_location: "Trend",
          user: current_user
          )
      end

    elsif params[:local]
      ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
      ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
      location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
      q = "geocode:#{location.latitude},#{location.longitude},1mi"
      @tweets = client.search(q).take(25)

      if current_user && check_previous(location.real_region_name)
        Search.create(
          query: location.real_region_name,
          trend_or_location: "Local",
          user: current_user
          )
      end

    elsif params[:location]
      location = params[:location]
      query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV["GOOGLE_GEOCODING"]}")
      top_result = query.first[1].first
      lat = top_result["geometry"]["location"]["lat"]
      lng = top_result["geometry"]["location"]["lng"]
      q = "geocode:#{lat},#{lng},5mi"
      @tweets = client.search(q).take(25)

      place_name = top_result["address_components"].first["long_name"]
      if current_user && check_previous(place_name)
        Search.create(
          query: place_name,
          trend_or_location: "Location",
          user: current_user
          )
      end
    end
  end
end
