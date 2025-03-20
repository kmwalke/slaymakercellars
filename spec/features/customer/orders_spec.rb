require 'rails_helper'

RSpec.describe 'Customer::Orders' do
  describe 'logged out' do
    it 'must be logged in to view customer page' do
      visit customer_order_path(create(:order))
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'admins cannot view customer page' do
      login_as_admin
      visit customer_order_path(create(:order))
      expect(page).to have_current_path(admin_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let(:current_user) { login_as_customer }
    let!(:order) { create(:order, contact: current_user.contact) }
    let!(:other_order) { create(:order, contact: create(:contact)) }

    describe 'customer page' do
      before do
        visit customer_path
        click_link order.id.to_s
      end

      it 'redirects to order path' do
        expect(page).to have_current_path(customer_order_path(order), ignore_query: true)
      end

      it 'shows a customers order' do
        expect(page).to have_content(order.id)
      end

      it 'does not show other customers order' do
        expect(page).to have_no_content(other_order.id)
      end
    end
  end
end
