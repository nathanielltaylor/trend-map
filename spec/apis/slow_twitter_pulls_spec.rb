require 'rails_helper'

feature 'app can make resource-intensive calls to twitter trend APIs', %{
  As site manager
  I want to be able to run the most resource-intensive tests separately
  So that I do not exhaust my quota running the test suite
}, dashboard: true do

  before(:each) do
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
  end

  scenario "app makes raw request to twitter available trends API" do
    query = api_get("https://api.twitter.com/1.1/trends/available.json")
    expect(query.code).to eq("200")
  end

  scenario "app makes raw request to twitter local trends API" do
    query = api_get("https://api.twitter.com/1.1/trends/place.json?id=2367105")
    expect(query.code).to eq("200")
  end
end
