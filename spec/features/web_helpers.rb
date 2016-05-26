def sign_user_up(email: 'test@example.com')
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: email)
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def leave_review(restaurant: 'KFC', thoughts: "Amazing!", rating: '5')
  visit '/restaurants'
  click_link('Review ' + restaurant)
  fill_in "Thoughts", with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end

def delete_kfc_review
  visit '/restaurants'
  click_link 'KFC profile'
  click_link 'Delete review'
end

def create_restaurant(name: 'KFC', description: 'The greatest chicken EVER.')
  visit '/restaurants'
  click_link 'Add a restaurant'
  fill_in 'Name', with: name
  fill_in 'Description', with: description
  click_button 'Create Restaurant'
end