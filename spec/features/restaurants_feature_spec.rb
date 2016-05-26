require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC', description: 'The greatest chicken EVER.')
    end
    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    context 'when user is logged in' do
      before do
        sign_user_up
      end
      scenario 'displays the new restaurant and adds to users restaurants' do
        create_restaurant
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
        user = User.find_by(email: 'test@example.com')
        expect(user.restaurants.count).to eq 1
      end
      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          create_restaurant(name: 'kf')
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end
    context 'when user is not logged in' do
      it 'fails' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).not_to have_button('Create Restaurant')
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){ Restaurant.create(name:'KFC', description: 'The greatest chicken EVER.') }
    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(page).to have_content 'The greatest chicken EVER.'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      sign_user_up
      create_restaurant
    end
    scenario 'let a logged in user edit their own restaurant' do
     visit '/restaurants'
     click_link 'Edit KFC'
     fill_in 'Name', with: 'Kentucky Fried Chicken'
     fill_in 'Description', with: 'Deep fried goodness'
     click_button 'Update Restaurant'
     expect(page).to have_content 'Kentucky Fried Chicken'
     expect(page).to have_content 'Deep fried goodness'
     expect(current_path).to eq '/restaurants'
    end

    scenario 'a user cannnot edit someone elses restaurant' do
      visit '/restaurants'
      click_link 'Sign out'
      sign_user_up(email: 'test2@example.com')
      click_link('Edit KFC')
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Error: Can only edit your own restaurant'
      restaurant = Restaurant.find_by(name: 'KFC')
    end
  end

  context 'deleting restaurants' do
    before do
      sign_user_up
      create_restaurant
    end
    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'a user cannnot delete someone elses restaurant' do
      click_link 'Sign out'
      sign_user_up(email: 'test2@example.com')
      click_link('Delete KFC')
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Error: Can only delete your own restaurant'
      user = User.find_by(email: 'test@example.com')
      expect(user.restaurants.count).to eq 1
    end
  end

end