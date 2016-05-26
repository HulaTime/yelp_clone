require 'rails_helper'

feature 'reviewing' do
  before do
    sign_user_up
    create_restaurant
  end

  scenario 'allows users to leave a review using a form' do
    leave_review
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('Amazing!')
  end

  scenario 'and the review belongs to the user' do
    leave_review
    user = User.find_by(email: 'test@example.com')
    expect(user.reviews.count).to eq 1
  end

  scenario 'user cannot review the same restaurant twice' do
    2.times { leave_review }
    user = User.find_by(email: 'test@example.com')
    expect(user.reviews.count).to eq 1
    expect(Review.all.count).to eq 1
  end

  context 'deleting reviews' do
    before do
      leave_review
    end
    scenario 'user can delete their own review' do
      delete_kfc_review
      expect(Review.all.count).to eq 0
      user = User.find_by(email: 'test@example.com')
      expect(user.reviews.count).to eq 0
    end
    scenario "user cannot delete someone else's review" do
      click_link 'Sign out'
      sign_user_up(email: 'second@example.com')
      delete_kfc_review
      expect(Review.all.count).to eq 1
      user = User.find_by(email: 'test@example.com')
      expect(user.reviews.count).to eq 1
    end
  end

  scenario 'displays an average rating for all reviews' do
    leave_review
    click_link 'Sign out'
    sign_user_up(email: 'poop@pooper.com')
    leave_review(rating: '2', thoughts: 'not bad')
    expect(page).to have_content 'Average Rating: 3.5'
  end

end