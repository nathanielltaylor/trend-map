require 'rails_helper'

feature 'user can search for location and search is saved to profile', %{
  As a user
  I want to be able to search for a location
  So that I can see what people are talking about anywhere
} do

  scenario "user searches for location" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit recommendations_path
    fill_in "location", with: "San Francisco"
    within ".location-search" do
      click_button "Search"
    end

    # tweet = double
    # user = double
    # location = double
    # @tweets = [tweet]
    # expect(tweet).to receive(:user).and_return(user)
    # expect(user).to receive(:screen_name).and_return("Bob")
    # expect(tweet).to receive(:text).and_return("This is a tweet")
    # expect(tweet).to receive(:place).and_return(location)
    # expect(location).to receive(:class).and_return(true)
    #
    # expect(page).to have_content("Bob")
    # expect(page).to have_content("This is a tweet")
    expect(page).to have_content("San Francisco, United States", minimum: 10)

    visit user_path(@user)
    expect(page).to have_content("San Francisco (Location)")
  end
end
