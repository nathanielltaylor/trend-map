require 'rails_helper'

feature 'app is connected to multiple third party APIs', %{
  As site manager
  I want to quickly check that essential API syntax has not changed
  So that I can troubleshoot more efficiently
}, dashboard: true do

  scenario "app connects to google geocoding API and returns lat and lng" do
    query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=#{ENV["GOOGLE_GEOCODING"]}")
    expect(query.first[1].first["geometry"]["location"]["lat"].round(2)).to eq(37.42)
    expect(query.first[1].first["geometry"]["location"]["lng"].round(2)).to eq(-122.08)
  end

  scenario "app connects to yahoo WOEID API and returns lat and lng" do
    query = HTTParty.get("http://where.yahooapis.com/v1/place/2367105?format=json&appid=#{ENV["YAHOO"]}")
    expect(query.first[1]["centroid"]["latitude"].round(2)).to eq(42.36)
    expect(query.first[1]["centroid"]["longitude"].round(2)).to eq(-71.06)
  end

  scenario "app makes search request to twitter API using twitter gem" do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    tweets = client.search("test").take(10)
    expect(tweets.length).to eq(10)
  end
end
