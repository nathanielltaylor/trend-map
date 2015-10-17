# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
bob = User.create!(email: "test1@test.com", username: "big bob", password: "testvdfv")
bill = User.create!(email: "test2@test.com", username: "billy", password: "testvfvgrbb")
sam = User.create!(email: "test3@test.com", username: "samuel", password: "testmjumui")
mary = User.create!(email: "test4@test.com", username: "mary", password: "testmjmui")

Search.create!(query: "Boston", trend_or_location: "Location", user: bob)
Search.create!(query: "Miami", trend_or_location: "Location", user: mary)
Search.create!(query: "Buenos Aires", trend_or_location: "Location", user: bill)
Search.create!(query: "debate", trend_or_location: "Trend", user: sam)
Search.create!(query: "trump", trend_or_location: "Trend", user: bob)
Search.create!(query: "HIV", trend_or_location: "Trend", user: mary)
Search.create!(query: "beyonce", trend_or_location: "Trend", user: bob)

Recommendation.create!(query: "trump", trend_or_location: "Trend", category: "Politics and Religion", user: bob)
Recommendation.create!(query: "love", trend_or_location: "Trend", category: "General", user: sam)
Recommendation.create!(query: "hoverboard", trend_or_location: "Trend", category: "Science and Technology", user: mary)
Recommendation.create!(query: "Pyongyang", trend_or_location: "Location", category: "Politics and Religion", user: bill)
