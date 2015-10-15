require 'rails_helper'

feature 'user can search for trend and search is saved to profile', %{
  As a user
  I want to be able to search for a trend
  So that I can see what people are saying about anything
} do

  scenario "user searches for trend / search is saved once" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit recommendations_path
    fill_in "search", with: "cats"
    within ".trend-search" do
      click_button "Search"
    end

    visit user_path(@user)
    expect(page).to have_content("cats")

    fill_in "search", with: "cats"
    within ".trend-search" do
      click_button "Search"
    end

    visit user_path(@user)
    expect(page).to have_content("cats", count: 1)
  end
end
