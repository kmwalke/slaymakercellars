require 'rails_helper'

RSpec.feature 'Customer::Orders', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view customer page' do
      visit customer_order_path(FactoryBot.create(:order))
      expect(current_path).to eq(login_path)
    end

    scenario 'admins cannot view customer page' do
      login_as_admin
      visit customer_order_path(FactoryBot.create(:order))
      expect(current_path).to eq(admin_path)
    end
  end

  describe 'logged in' do
    before :each do
      @current_user = login_as_customer
      @order        = FactoryBot.create(:order, contact: @current_user.contact)
    end

    scenario 'display page' do
      visit customer_path
      click_link @order.id.to_s

      expect(current_path).to eq(customer_order_path(@order))
      expect(page).to have_content(@order.id)
    end
  end
end
