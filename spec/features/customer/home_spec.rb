require 'rails_helper'

RSpec.describe 'Customer::Home' do
  describe 'logged out' do
    it 'must be logged in to view customer page' do
      visit '/customer'
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'admins cannot view customer page' do
      login_as_admin
      visit customer_path
      expect(page).to have_current_path(admin_path, ignore_query: true)
    end
  end

  describe 'logged in but unactivated' do
    before do
      login_as(create(:customer, contact: nil))
    end

    it 'shows an info page for unactivated customers' do
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end

    it 'renders info page' do
      expect(page).to have_content('has not been activated')
    end
  end

  describe 'logged in' do
    let!(:current_user) { login_as_customer }

    before do
      visit '/customer'
    end

    it 'display page' do
      expect(page).to have_content('Customer Portal')
    end

    it 'display past orders' do
      create(:order, contact: current_user.contact)
      visit '/customer'
      expect(page).to have_content(current_user.contact.orders.last.id)
    end

    it 'does not display voided orders' do
      deleted_order = create(:order, contact: current_user.contact, deleted_at: DateTime.now)
      visit '/customer'
      expect(page).not_to have_content(deleted_order.id)
    end

    it 'does not display other customers orders' do
      other_order = create(:order)
      visit '/customer'
      expect(page).not_to have_content(other_order.id)
    end

    describe 'display open order status' do
      let!(:open_order) { create(:order, contact: current_user.contact) }

      before do
        visit '/customer'
      end

      it 'shows in process order' do
        expect(page).to have_content(open_order.id)
      end

      it 'shows in process order status' do
        expect(page).to have_content('In Process')
      end
    end

    describe 'display delivered order status' do
      let!(:delivered_order) do
        create(
          :order,
          contact: current_user.contact,
          delivery_date: Date.yesterday,
          fulfilled_on: Date.today
        )
      end

      before do
        visit '/customer'
      end

      it 'shows delivered order' do
        expect(page).to have_content(delivered_order.id)
      end

      it 'shows delivered order status' do
        expect(page).to have_content('Delivered')
      end
    end

    it 'do not show xero link when invoice not created' do
      create(:order, contact: current_user.contact)
      visit '/customer'
      expect(page).not_to have_content('View Invoice')
    end
  end
end
