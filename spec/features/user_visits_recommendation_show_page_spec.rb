require 'rails_helper'

feature 'recommendation show page shows details on that recommendation', %{
  As a user
  I want to be able to click a search to get more info
  So that I can see more information about this recommendation
} do

  scenario "user visits rec index page" do
    rec = FactoryGirl.create(:recommendation)

    visit recommendations_path
    click_link "Boston"
    expect("/recommendations/#{rec.id}").to eq(current_path)
    expect(page).to have_content("Boston")
    expect(page).to have_content("Trend")
    expect(page).to have_content("General")
    expect(page).to have_content(
      "I like to know what people are saying around where I live"
    )
  end

end
