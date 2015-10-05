class User < ActiveRecord::Base
  has_many :searches
  has_many :recommendations
  # 
  # geocoded_by :ip_address
  #   :latitude => :latitude, :longitude => :longitude
  # after_validation :geocode

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
