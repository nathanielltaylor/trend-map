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
end
