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

    describe 'navigates directly to Admin::DeliveryRoute' do
      before do
        visit admin_path
        click_link('Create a Delivery Route')
      end

      it 'renders the delivery route page' do
        expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)
      end

      it 'renders the title' do
        expect(page).to have_content('Delivery Route')
      end
    end

    describe 'navigates from orders to Admin::DeliveryRoute' do
      before do
        visit admin_orders_path
        click_link('Create a Delivery Route')
      end

      it 'renders the delivery route page' do
        expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)
      end

      it 'renders the title' do
        expect(page).to have_content('Delivery Route')
      end
    end

    describe 'creates a delivery route' do
      before do
        visit admin_delivery_route_path

        Order.all[1..5].each do |order|
          page.check("order_#{order.id}")
        end

        click_button 'Create'
      end

      it 'renders the delivery route page' do
        expect(page).to have_current_path(admin_delivery_route_path, ignore_query: true)
      end

      it 'shows your delivery route' do
        expect(page).to have_content('Your Delivery Route')
      end
    end
  end
end
