require 'rails_helper'

RSpec.feature 'Admin::Users', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage users' do
      visit admin_users_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:user) { User.create(name: 'name1', email: 'name1@place.com', password: '123') }

    before :each do
      login
    end

    scenario 'list users' do
      visit admin_users_path
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
    end

    scenario 'create a user' do
      user2 = User.new(name: 'name2', email: 'name2@place.com', password: '123')
      visit admin_users_path

      click_link 'New User'
      fill_in_form(user2)
      click_button 'Create User'

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content(user2.name)
    end

    scenario 'edit a user' do
      visit admin_users_path

      click_link user.name
      user.name = 'new name'
      fill_in_form(user)
      click_button 'Update User'

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content(user.name)
    end

    scenario 'delete a user' do
      user_id = user.id
      visit admin_users_path

      click_link "delete_#{user.id}"
      expect(current_path).to eq(admin_users_path)
      expect(User.find_by_id(user_id)).to be_nil
    end
  end

  def fill_in_form(user)
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
  end
end
