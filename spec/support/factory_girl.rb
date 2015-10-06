require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :recommendation do
    query "Boston"
    trend_or_location "Trend"
    category "General"
    description "I like to know what people are saying around where I live"
    association :user
  end

end
