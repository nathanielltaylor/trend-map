class TweetsController < ApplicationController

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    query = params[:search]
    @tweets = client.search("##{query}").take(10)

    if current_user
      Search.create(query: params[:search], trend_or_location: true, user: current_user)
    end
  end

end
