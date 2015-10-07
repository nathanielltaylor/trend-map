class HomesController < ApplicationController
  def index
    ip_address = request.remote_ip unless Rails.env.test? || Rails.env.development?
    ip_address = "50.241.127.209" if Rails.env.test? || Rails.env.development?
    location = GeoIP.new('GeoLiteCity.dat').city(ip_address)
    @lat = location.latitude
    @lng = location.longitude
  end
end
