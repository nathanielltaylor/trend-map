class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :username)
    end
  end

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

  def check_previous(new_search)
    previous = current_user.searches.all
    previous.each do |s|
      if s.query == new_search
        return false
      end
      true
    end
  end

  def find_center(tweets)
    ave_lat = 0
    ave_lng = 0
    if tweets.length > 0
      tweets.each do |t|
        ave_lat += t.geo.coordinates[0]
        ave_lng += t.geo.coordinates[1]
      end
      return [(ave_lat / @tweets.length), (ave_lng / @tweets.length)]
    else
      nil
    end
  end

  def get_analysis(tweets)
    if current_user
      Indico.api_key = ENV["INDICO"]
      text = []
      tweets.each { |t| text << t.text }
      all = Indico.sentiment(text)
      ((all.reduce(:+).to_f / all.size) * 100).round(2)
    else
      nil
    end
  end

  CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
    config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
    config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
  end
end
