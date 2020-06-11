require "rails_helper"

RSpec.feature 'Users', :type => :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage users' do
      visit users_path
      expect(current_path).to eq(root_path)
    end
  end

  describe 'logged in' do
    let!(:user) { User.create(name: 'name1', email: 'name1@place.com', password: '123') }

    before :each do
      login
    end

    scenario 'list users' do
      visit users_path
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
    end

    scenario 'create a user' do
      visit users_path

      click_link 'New User'

      fill_in 'Name', with: 'name2'
      fill_in 'Email', with: 'name2@place.com'
      fill_in 'Password', with: '123'
      fill_in 'Password confirmation', with: '123'
      click_button 'Create User'

      expect(current_path).to eq(users_path)
      expect(page).to have_content('name2')
    end

    scenario 'edit a user' do
      visit users_path

    end

    scenario 'delete a user' do
      visit users_path

    end
  end
end