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
      first(:link, 'Users').click
      expect(current_path).to eq(admin_users_path)
    end

    scenario 'product link' do
      first(:link, 'Products').click
      expect(current_path).to eq(admin_products_path)
    end

    scenario 'contact link' do
      first(:link, 'Contacts').click
      expect(current_path).to eq(admin_contacts_path)
    end

    scenario 'towns link' do
      first(:link, 'View Towns').click
      expect(current_path).to eq(admin_towns_path)
    end

    scenario 'states link' do
      first(:link, 'View States').click
      expect(current_path).to eq(admin_states_path)
    end
  end
end
