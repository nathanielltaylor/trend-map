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
      @tweets = client.search("##{query}").take(10) # TWITTER GEM
      if current_user
        Search.create(query: params[:search], trend_or_location: true, user: current_user)
      end
    elsif params[:location]
      ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
        ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
      location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
      q = "geocode:#{location.latitude},#{location.longitude},1mi"
      @tweets = client.search(q).take(25)
      # binding.pry
      if current_user
        Search.create(query: location.real_region_name, trend_or_location: true, user: current_user)
      end
      # "/1.1/search/tweets.json?geocode=#{location.latitude},#{location.longitude},100mi&count=50"
      # client = Grackle::Client.new(
      #   :auth=>{
      #     :ssl=>true,
      #     :handlers=>{:json=>Grackle::Handlers::StringHandler.new},
      #     :type=>:oauth,
      #     :consumer_key=>'ENV["TWITTER_CONSUMER_KEY"]', :consumer_secret=>'ENV["TWITTER_CONSUMER_SECRET"]',
      #     :token=>'ENV["TWITTER_ACCESS_TOKEN"]', :token_secret=>'ENV["TWITTER_ACCESS_SECRET"]'
      # })
      # client.search.tweets?(q)

    end

  end


end
