class Recommendation < ActiveRecord::Base
  belongs_to :user

  validates :query, presence: true
  validates :trend_or_location, presence: true
  validates :trend_or_location, inclusion: { in: ["Trend", "Location"] }
  validates :category, presence: true
  validates :user_id, presence: true
end
