require 'rails_helper'

RSpec.feature 'Admin::Home', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit '/admin'
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    before :each do
      login
      visit '/admin'
    end

    scenario 'display page' do
      expect(page).to have_content('Administration')
    end

    scenario 'user link' do
      click_link 'Users'
      expect(current_path).to eq(admin_users_path)
    end
  end
end
