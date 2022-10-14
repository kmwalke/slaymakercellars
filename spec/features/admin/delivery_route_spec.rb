require 'rails_helper'

describe 'Admin::DeliveryRoute', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit admin_delivery_route_path
      expect(current_path).to eq(login_path)
    end

    scenario 'customers cannot view admin page' do
      login_as_customer
      visit admin_delivery_route_path
      expect(current_path).to eq(customer_path)
    end
  end

  describe 'logged in' do
    before :each do
      login_as_admin
      10.times do
        FactoryBot.create(:order)
      end
    end

    it 'navigates directly to Admin::DeliveryRoute' do
      visit admin_path
      click_link('Create a Delivery Route')

      expect(current_path).to eq(admin_delivery_route_path)
      expect(page).to have_content('Delivery Route')
    end

    it 'navigates from orders to Admin::DeliveryRoute' do
      visit admin_orders_path
      click_link('Create a Delivery Route')

      expect(current_path).to eq(admin_delivery_route_path)
      expect(page).to have_content('Orders')
    end

    it 'creates a delivery route' do
      expect(true).to eq(false)
    end
  end
end
