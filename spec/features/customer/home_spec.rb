require 'rails_helper'

RSpec.feature 'Customer::Home', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view customer page' do
      visit '/customer'
      expect(current_path).to eq(login_path)
    end

    scenario 'admins cannot view customer page' do
      login_as_admin
      visit customer_path
      expect(current_path).to eq(admin_path)
    end
  end

  describe 'logged in' do
    before :each do
      login_as_customer
      visit '/customer'
    end

    scenario 'display page' do
      expect(page).to have_content('Customer Portal')
    end

    scenario 'display past orders' do
      expect(true).to be false
    end

    scenario 'display open order status' do
      expect(true).to be false
    end

    scenario 'display open invoice status' do
      expect(true).to be false
    end

    scenario 'link to xero invoice' do
      expect(true).to be false
      #https://developer.xero.com/documentation/api/accounting/invoices/#retrieving-the-online-invoice-url
      # Probably should save that link in the db.  Maybe
    end
  end
end
