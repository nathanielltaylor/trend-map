class Recommendation < ActiveRecord::Base
  belongs_to :user

  validates :query, presence: true
  validates :type, presence: true
  validates :category, presence: true
  validates :user_id, presence: true
end
