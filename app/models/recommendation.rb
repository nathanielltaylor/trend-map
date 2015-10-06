class Recommendation < ActiveRecord::Base
  belongs_to :user

  validates :query, presence: true
  validates :trend_or_location, presence: true
  validates :trend_or_location, inclusion: { in: ["Trend", "Location"] }
  validates :category, presence: true
  validates :category, inclusion: { in: [
    'General',
    'Politics and Religion',
    'Business and Economics',
    'Science and Technology',
    'Sports and Entertainment'] }
  validates :user_id, presence: true

  acts_as_votable

  def score
    get_upvotes.size - get_downvotes.size
  end
end
