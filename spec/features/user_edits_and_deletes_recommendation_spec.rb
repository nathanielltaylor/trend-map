require 'rails_helper'

feature 'user can edit recommendation', %{
  As a user
  I want to be able to edit the recommendations I make
  So that I can fix any mistakes I made while entering the form
} do

  # scenario "user edits recommendation" do
  #   @user = FactoryGirl.create(:user)
  #   login(@user)
  #   FactoryGirl.create(:recommendation, user: @user)
  #
  #   visit recommendations_path
  #   click_link "Boston"
  #   click_link "Edit Suggestion"
  #   fill_in "Query", with: "Syria"
  #   select "Trend", from: "Trend or location"
  #   select "Politics and Religion", from: "Category"
  #   fill_in "Description", with: "tweets from the frontlines"
  #   click_button "Submit"
  #
  #   expect(page).to have_content("Syria")
  #   expect(page).to have_content("Trend ")
  #   expect(page).to have_content("Politics and Religion")
  #   expect(page).to have_content("tweets from the frontlines")
  #
  # end

end

feature 'user can delete recommendation', %{
  As a user
  I want to be able to delete recommendations I make entirely
  So that I can change my mind about what I post
} do

  scenario "user deletes recommendation" do
    @user = FactoryGirl.create(:user)
    login(@user)
    FactoryGirl.create(:recommendation, user: @user)

    visit recommendations_path
    click_link "Boston"
    click_link "Edit Suggestion"
    click_link "Delete"

    expect(page).to_not have_content("Boston")
    expect(page).to_not have_content(
      "I like to know what people are saying around where I live"
    )
  end

end
