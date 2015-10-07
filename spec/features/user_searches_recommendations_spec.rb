require 'rails_helper'

feature 'user can search recommendations', %{
  As a user
  I want to be able to search other people's recommendations
  So that I can see which ones match my interests
} do

  before(:each) do
    FactoryGirl.create(:recommendation)
    FactoryGirl.create(
      :recommendation,
      query: "Los Angeles",
      trend_or_location: "Location",
      category: "Sports and Entertainment")
    FactoryGirl.create(
      :recommendation,
      query: "cats",
      trend_or_location: "Trend",
      category: "Sports and Entertainment")
    FactoryGirl.create(
      :recommendation,
      query: "patriots",
      trend_or_location: "Trend",
      category: "Sports and Entertainment")
    FactoryGirl.create(
      :recommendation,
      query: "quark",
      trend_or_location: "Trend",
      category: "Science and Technology")
  end

  scenario "user searches recommendations with only query" do
    visit recommendations_path
    fill_in "user_search", with: "boston"
    within(".rec-search") do
      click_button "Search"
    end

    expect(page).to have_content "Boston"

    expect(page).to_not have_content "Los Angeles"
    expect(page).to_not have_content "cats"
    expect(page).to_not have_content "patriots"
    expect(page).to_not have_content "quark"
  end

  scenario "user filters trend vs. location and category" do
    visit recommendations_path
    select "Trend", from: "trend_or_location"
    select "Sports and Entertainment", from: "category"
    within(".rec-search") do
      click_button "Search"
    end

    expect(page).to have_content "cats"
    expect(page).to have_content "patriots"

    expect(page).to_not have_content "boston"
    expect(page).to_not have_content "Los Angeles"
    expect(page).to_not have_content "quark"
  end
end
