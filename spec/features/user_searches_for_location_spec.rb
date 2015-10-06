require 'rails_helper'

feature 'user can search for location', %{
  As a user
  I want to be able to search for a location
  So that I can see what people are talking about anywhere
} do

  scenario "user searches for location" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit root_path
    fill_in "location", with: "San Francisco"
    within ".location-search" do
      click_button "Search"
    end
    visit user_path(@user)
    expect(page).to have_content("San Francisco (Location)")
  end
end
