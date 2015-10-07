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
    @tweets = client.search(q).take(25)
  end
end
