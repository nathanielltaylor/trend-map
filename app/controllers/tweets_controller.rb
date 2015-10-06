class TweetsController < ApplicationController

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    if params[:search]
      query = params[:search]
      @tweets = client.search("##{query}").take(25)
      if current_user
        Search.create(query: params[:search], trend_or_location: "Trend", user: current_user)
      end
    elsif params[:local]
      ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
        ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
      location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
      q = "geocode:#{location.latitude},#{location.longitude},1mi"
      @tweets = client.search(q).take(25)
      # binding.pry
      if current_user
        Search.create(query: location.real_region_name, trend_or_location: "Location", user: current_user)
      end
    elsif params[:location]
      location = params[:location]
      query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=AIzaSyCCAhlkiSK9wpBRhmfK_MxzXqflAQRf784")
      lat = query.first[1].first["geometry"]["location"]["lat"]
      lng = query.first[1].first["geometry"]["location"]["lng"]
      q = "geocode:#{lat},#{lng},5mi"

      @tweets = client.search(q).take(25)


    end

  end


end
