require 'rails_helper'

feature 'user can search for location and search is saved to profile', %{
  As a user
  I want to be able to search for a location
  So that I can see what people are talking about anywhere
} do

  scenario "user searches for location / search is saved once" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit recommendations_path
    fill_in "location", with: "San Francisco"
    within ".location-search" do
      click_button "Search"
    end

    visit user_path(@user)
    expect(page).to have_content("San Francisco")

    fill_in "location", with: "San Francisco"
    within ".location-search" do
      click_button "Search"
    end

    visit user_path(@user)
    expect(page).to have_content("San Francisco", count: 1)
  end
end
