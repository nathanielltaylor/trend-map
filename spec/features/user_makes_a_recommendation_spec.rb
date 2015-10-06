require 'rails_helper'

feature 'user can add new recommendation', %{
  As a signed-in user
  I want to be able to recommend searches to other users
  So that I can share my interesting discoveries with others
} do

  scenario "user adds new recommendation successfully" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit root_path
    click_button("Suggested Searches")
    click_link("Suggest a New Search")

    fill_in "Query", with: "Pope"
    select "Trend", from: "Trend or location"
    select "Politics and Religion", from: "Category"
    fill_in "Description", with: "I want to know everything about the Pope!!!"
    click_button "Submit"

    expect(page).to have_content("Pope")
    expect(page).to have_content("Trend")
    expect(page).to have_content("Politics and Religion")
    expect(page).to have_content("I want to know everything about the Pope!!!")
  end

  scenario "users leaves required recommendation fields blank" do
    @user = FactoryGirl.create(:user)
    login(@user)

    visit root_path
    click_button("Suggested Searches")
    click_link("Suggest a New Search")

    click_button "Submit"

    expect(page).to have_content("Query can't be blank")
  end

  scenario "signed out visitor cannot create recommendation" do
    visit recommendations_path
    expect(page).to_not have_content("Suggest a New Search")
    visit new_recommendation_path
    expect(page).to have_content(
      "Please sign in or create an account to suggest a search."
    )
  end

end
