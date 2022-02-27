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

  describe 'logged in but unactivated' do
    scenario 'shows an info page for unactivated customers' do
      login_as(FactoryBot.create(:customer, contact: nil))
      expect(current_path).to eq(customer_path)
      expect(page).to have_content('has not been activated')
    end
  end

  describe 'logged in' do
    before :each do
      @current_user = login_as_customer
      visit '/customer'
    end

    scenario 'display page' do
      expect(page).to have_content('Customer Portal')
    end

    scenario 'display past orders' do
      FactoryBot.create(:order, contact: @current_user.contact)
      visit '/customer'
      expect(page).to have_content(@current_user.contact.orders.last.id)
    end

    scenario 'does not display voided orders' do
      deleted_order = FactoryBot.create(:order, contact: @current_user.contact, deleted_at: DateTime.now)
      visit '/customer'
      expect(page).not_to have_content(deleted_order.id)
    end

    scenario 'does not display other customers orders' do
      other_order = FactoryBot.create(:order)
      visit '/customer'
      expect(page).not_to have_content(other_order.id)
    end

    scenario 'display open order status' do
      open_order = FactoryBot.create(:order, contact: @current_user.contact)
      visit '/customer'
      expect(page).to have_content(open_order.id)
      expect(page).to have_content('In Process')
    end

    scenario 'display delivered order status' do
      delivered_order = FactoryBot.create(
        :order,
        contact: @current_user.contact,
        delivery_date: Date.yesterday,
        fulfilled_on: Date.today
      )
      visit '/customer'
      expect(page).to have_content(delivered_order.id)
      expect(page).to have_content('Delivered')
    end

    scenario 'do not show xero link when invoice not created' do
      FactoryBot.create(:order, contact: @current_user.contact)
      visit '/customer'
      expect(page).not_to have_content('View Invoice')
    end

    scenario 'display open invoice status', skip: 'not implemented' do
      expect(true).to be false
    end

    scenario 'link to xero invoice', skip: 'not implemented' do
      expect(true).to be false
      # https://developer.xero.com/documentation/api/accounting/invoices/#retrieving-the-online-invoice-url
      # Probably should save that link in the db.  Maybe
    end
  end
end
