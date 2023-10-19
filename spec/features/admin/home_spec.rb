require 'rails_helper'

RSpec.describe 'Admin::Home' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit '/admin'
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit '/admin'
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    before do
      login_as_admin
      visit '/admin'
    end

    it 'display page' do
      expect(page).to have_content('Administration')
    end

    it 'user link' do
      first(:link, 'Users').click
      expect(page).to have_current_path(admin_users_path, ignore_query: true)
    end

    it 'product link' do
      first(:link, 'Products').click
      expect(page).to have_current_path(admin_products_path, ignore_query: true)
    end

    it 'contact link' do
      first(:link, 'Contacts').click
      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
    end

    it 'towns link' do
      first(:link, 'View Towns').click
      expect(page).to have_current_path(admin_towns_path, ignore_query: true)
    end

    it 'states link' do
      first(:link, 'View States').click
      expect(page).to have_current_path(admin_states_path, ignore_query: true)
    end

    it 'sales reps link' do
      first(:link, 'Sales Reps').click
      expect(page).to have_current_path(admin_sales_reps_path, ignore_query: true)
    end

    it 'reports link' do
      first(:link, 'Reports').click
      expect(page).to have_current_path(admin_reports_path, ignore_query: true)
    end
  end
end
