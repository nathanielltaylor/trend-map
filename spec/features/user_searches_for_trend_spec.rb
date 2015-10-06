require 'rails_helper'

feature 'user can search for trend', %{
  As a user
  I want to be able to search for a trend
  So that I can see what people are saying about anything
} do

  scenario "user searches for trend" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit root_path
    fill_in "search", with: "cats"
    within ".trend-search" do
      click_button "Search"
    end
    visit user_path(@user)
    expect(page).to have_content("cats (Trend)")
  end
end
