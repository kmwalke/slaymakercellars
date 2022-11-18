require 'rails_helper'

describe 'Admin::DeliveryRoute' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit admin_delivery_route_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_delivery_route_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    before do
      login_as_admin
      create_list(:order, 10)
    end

    it 'navigates directly to Admin::DeliveryRoute' do
      visit admin_path
      click_link('Create a Delivery Route')

      expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)
      expect(page).to have_content('Delivery Route')
    end

    it 'navigates from orders to Admin::DeliveryRoute' do
      visit admin_orders_path
      click_link('Create a Delivery Route')

      expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)
      expect(page).to have_content('Orders')
    end

    it 'creates a delivery route' do
      visit admin_delivery_route_path

      Order.all[1..5].each do |order|
        page.check("order_#{order.id}")
      end

      click_button 'Create'

      expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)

      expect(page).to have_content('Your Delivery Route')
    end
  end
end
