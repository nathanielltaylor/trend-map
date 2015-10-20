class ResultsController < ApplicationController
  def index
    if params[:search].present?
      query = params[:search]
      q = "#{query}&geocode:39.5,-98.35,1500mi"
      @zoom_level = 4
      if current_user && check_previous(query)
        Search.create(
          query: params[:search],
          trend_or_location: "Trend",
          user: current_user
          )
      end

    elsif params[:local].present?
      location = find_user
      q = "geocode:#{location.latitude},#{location.longitude},10mi"
      @zoom_level = 13
      if current_user && check_previous(location.real_region_name)
        Search.create(
          query: location.real_region_name,
          trend_or_location: "Local",
          user: current_user
          )
      end

    elsif params[:location].present?
      location = params[:location]
      query = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV["GOOGLE_GEOCODING"]}")
      top_result = query.first[1].first
      lat = top_result["geometry"]["location"]["lat"]
      lng = top_result["geometry"]["location"]["lng"]
      q = "geocode:#{lat},#{lng},5mi"
      @zoom_level = 13
      place_name = top_result["address_components"].first["long_name"]
      if current_user && check_previous(place_name)
        Search.create(
          query: place_name,
          trend_or_location: "Location",
          user: current_user
          )
      end
    end

    tweets = CLIENT.search(q).take(25)
    collection = TweetCollection.new(tweets)
    @tweets = collection.clean
    @sentiment = collection.get_analysis if current_user
    @face = collection.get_face
    @center = collection.find_center

    respond_to do |format|
      format.html
      format.json { render json: [@tweets, @center, @zoom_level] }
    end
  end
end
