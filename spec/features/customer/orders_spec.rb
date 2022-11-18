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
    before do
      @current_user = login_as_customer
      @order        = create(:order, contact: @current_user.contact)
    end

    it 'display page' do
      visit customer_path
      click_link @order.id.to_s

      expect(page).to have_current_path(customer_order_path(@order), ignore_query: true)
      expect(page).to have_content(@order.id)
    end
  end
end
