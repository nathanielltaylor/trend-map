require 'rails_helper'

feature 'user can delete searches', %{
  As a user
  I want to be able to delete my saved searches
  To protect my privacy and keep my profile clean
} do

  before(:each) do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:search, user: @user)
    login(@user)
  end

  scenario "user deletes a search" do
    visit user_path(@user)
    expect(page).to have_content("Lima")

    click_link "Delete"

    expect(page).to_not have_content("Lima")
  end

  scenario "user deletes all searches" do
    FactoryGirl.create(
      :search,
      query: "Buenos Aires",
      user: @user
    )
    FactoryGirl.create(
      :search,
      query: "#AMAs",
      trend_or_location: "Trend",
      user: @user
    )
    visit user_path(@user)
    expect(page).to have_content("Lima")
    expect(page).to have_content("Buenos Aires")
    expect(page).to have_content("#AMAs")

    click_link "Clear all Search History"

    expect(page).to_not have_content("Lima")
    expect(page).to_not have_content("Buenos Aires")
    expect(page).to_not have_content("#AMAs")
  end

end
