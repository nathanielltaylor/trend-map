require 'rails_helper'

feature 'user can vote', %{
  As a signed in user,
  I want to be able to vote on recommended searches (up and down)
  So that the most interesting ones are the most visible
} do

  scenario "user sees buttons" do
    FactoryGirl.create(:recommendation)
    visit recommendations_path
    expect(page).to have_content('▲')
    expect(page).to have_content('▼')
  end

  scenario "user gets one upvote or downvote per rec but can switch between", js: true, faulty: true do
    @user = FactoryGirl.create(:user)
    login(@user)
    rec = FactoryGirl.create(:recommendation, user: @user)

    visit recommendations_path
    within(".update-rating-#{rec.id}") do
      expect(page).to have_content("0")
    end
    click_link '▲'
    within("update-rating-#{rec.id}") do
      expect(page).to have_content("1")
    end
    click_link '▲'
    within("update-rating-#{rec.id}") do
      expect(page).to have_content("1")
    end
    click_link '▼'
    within("update-rating-#{rec.id}") do
      expect(page).to have_content("-1")
    end
    click_link '▼'
    within("update-rating-#{rec.id}") do
      expect(page).to have_content("-1")
    end
  end
end
