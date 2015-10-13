class Tweet < ActiveRecord::Base
  validates :text, presence: true
  validates :latitude, presence: true
  validates :latitude, numericality: {
    greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0
  }
  validates :longitude, presence: true
  validates :longitude, numericality: {
    greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0
  }
end
