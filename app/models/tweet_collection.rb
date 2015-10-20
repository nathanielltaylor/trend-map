class TweetCollection
  attr_accessor :tweets, :sentiment

  def initialize(tweets)
    @tweets = tweets
    @sentiment = nil
  end

  def clean
    @tweets.delete_if { |t| t.place.class == Twitter::NullObject }
  end

  def find_center
    ave_lat = 0
    ave_lng = 0
    if @tweets.length > 0
      @tweets.each do |t|
        ave_lat += t.geo.coordinates[0]
        ave_lng += t.geo.coordinates[1]
      end
      return [(ave_lat / @tweets.length), (ave_lng / @tweets.length)]
    else
      nil
    end
  end

  def get_analysis
    Indico.api_key = ENV["INDICO"]
    text = []
    @tweets.each { |t| text << t.text }
    all = Indico.sentiment(text)
    @sentiment = ((all.reduce(:+).to_f / all.size) * 100).round(2)
  end

  def get_face
    if @sentiment
      if @sentiment >= 60.0
        @face = "happy.png"
      elsif @sentiment >= 40.0
        @face = "neutral.png"
      else
        @face = "unhappy.png"
      end
      @face
    else
      nil
    end
  end

end
