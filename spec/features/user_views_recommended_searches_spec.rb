require 'rails_helper'

feature 'recommendation index page shows all recommendations', %{
  As a user
  I want to see a page with all of the searches that people have recommended
  So that I can get an idea of what kind of information this app allows me to see
} do

  scenario "user visits rec index page" do
    FactoryGirl.create(:recommendation)

    # @user = FactoryGirl.create(:user)
    # login(@user)
    visit root_path
    click_button("Suggested Searches")
    expect(page).to have_content("Boston")
    expect(page).to have_content("Trend")
    expect(page).to have_content("General")
    expect(page).to have_content("I like to know what people are saying around where I live")
  end

end