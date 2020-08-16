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

    scenario 'product link' do
      click_link 'Products'
      expect(current_path).to eq(admin_products_path)
    end

    scenario 'contact link' do
      click_link 'Contact'
      expect(current_path).to eq(admin_contacts_path)
    end

    scenario 'towns link' do
      click_link 'Towns'
      expect(current_path).to eq(admin_towns_path)
    end

    scenario 'state link' do
      click_link 'States'
      expect(current_path).to eq(admin_states_path)
    end
  end
end
