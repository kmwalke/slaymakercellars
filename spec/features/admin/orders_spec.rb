require 'rails_helper'

describe 'Admin::Orders', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit admin_orders_path
      expect(current_path).to eq(login_path)
    end

    scenario 'customers cannot view admin page' do
      login_as_customer
      visit admin_orders_path
      expect(current_path).to eq(customer_path)
    end
  end

  describe 'logged in' do
    before :each do
      login_as_admin
    end

    let!(:order) { FactoryBot.create(:order) }

    it 'opens Admin::Orders' do
      visit admin_orders_path

      expect(current_path).to eq(admin_orders_path)
      expect(page).to have_content('Orders')
    end

    it 'creates an order' do
      visit admin_orders_path

      first(:link, 'New Order').click
      expect(current_path).to eq(new_admin_order_path)

      fill_in 'Contact', with: order.contact.name
      fill_in 'Delivery date', with: order.delivery_date

      click_button 'Save'
      expect(current_path).to eq(admin_orders_path)
      expect(page).to have_content('created')
    end

    it 'updates an order' do
      new_date = order.delivery_date + 1
      visit admin_orders_path

      click_link order.contact.name
      expect(current_path).to eq(edit_admin_order_path(order.id))

      fill_in 'Delivery date', with: new_date

      first(:button, 'Update').click
      expect(current_path).to eq(edit_admin_order_path(order.id))
      expect(Order.find_by_id(order.id).delivery_date).to eq(new_date)

      fill_in 'Delivery date', with: new_date + 1
      first(:button, 'Save & Finish').click
      expect(current_path).to eq(admin_orders_path)
      expect(Order.find_by_id(order.id).delivery_date).to eq(new_date + 1)
    end

    it 'records users creating orders' do
      visit edit_admin_order_path(order.id)

      expect(page).to have_content('Created by')
      expect(page).to have_content(order.created_by.name)
    end

    it 'records users updating orders' do
      user2 = login_as_admin

      visit edit_admin_order_path(order.id)
      new_date = order.delivery_date + 1
      fill_in 'Delivery date', with: new_date

      first(:button, 'Update').click

      visit edit_admin_order_path(order.id)
      expect(page).to have_content('Updated by')
      expect(page).to have_content(user2.name)
    end

    it 'deletes an order from index' do
      visit admin_orders_path

      click_link "void_#{order.id}"

      expect(current_path).to eq(admin_orders_path)
      expect(Order.find_by_id(order.id).deleted_at).to_not be_nil
    end

    it 'deletes an order from order page' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'Void'

      expect(current_path).to eq(admin_orders_path)
      expect(Order.find_by_id(order.id).deleted_at).to_not be_nil
    end

    it 'delivers an order from index' do
      visit admin_orders_path

      click_link "deliver_#{order.id}"

      expect(current_path).to eq(admin_orders_path)
      expect(Order.find_by_id(order.id).fulfilled_on).not_to eq(nil)
    end

    it 'delivers an order from order page' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'Mark Delivered'

      expect(current_path).to eq(admin_orders_path)
      expect(Order.find_by_id(order.id).fulfilled_on).not_to eq(nil)
    end

    it 'shows delivered orders' do
      order.fulfill
      visit admin_orders_path

      click_link 'Delivered Orders'

      expect(current_path).to eq(admin_orders_path)
      expect(page).to have_content(order.id)
    end

    it 'shows a delivered order' do
      order.fulfill
      visit edit_admin_order_path(order.id)

      expect(current_path).to eq(admin_order_path(order.id))

      expect(page).to have_content(order.id)
    end

    it 'undelivers an order' do
      order.fulfill

      visit admin_orders_path
      click_link 'Delivered Orders'
      click_link order.contact.name
      click_link 'Undeliver'

      expect(current_path).to eq(edit_admin_order_path(order.id))
      expect(Order.find_by_id(order.id).fulfilled_on).to eq(nil)
    end

    it 'views all orders by a contact' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'View all orders'

      expect(current_path).to eq(admin_orders_path)
    end

    it 'shows late orders' do
      order.update(delivery_date: Date.yesterday)

      visit admin_orders_path
      click_on 'Late Orders'

      expect(page).to have_content(order.contact.name)
      expect(page).to have_content(order.id)
    end

    it 'assigns orders to a user' do
      admin = User.admins.first
      visit edit_admin_order_path(order.id)

      select admin.name, from: 'order_user_id'
      first(:button, 'Update').click

      expect(order.reload.user).to eq(admin)
    end

    describe 'sync' do
      scenario 'shows xero sync errors' do
        message = 'bad email'
        order.xero_sync_errors << XeroSyncError.new(message:)

        visit edit_admin_order_path(order)

        expect(page).to have_content(message)
      end

      scenario 'does not show xero link for unsynced on edit' do
        visit edit_admin_order_path(order)

        expect(page).not_to have_content('Open Invoice')
        expect(page).to have_content('Create Invoice')
      end

      scenario 'does not show xero link for unsynced on show' do
        visit admin_order_path(order)

        expect(page).not_to have_content('Open Invoice')
        expect(page).to have_content('Create Invoice')
      end

      scenario 'shows xero link for synced' do
        order.update(xero_id: 'abc123')
        visit admin_order_path(order)

        expect(page).to have_content('Open Invoice')
        expect(page).not_to have_content('Create Invoice')
      end

      scenario 'does not allow editing of orders with an invoice' do
        order.update(xero_id: 'abc123')

        visit edit_admin_order_path(order)

        expect(current_path).to eq(admin_order_path(order))
      end

      scenario 'links to show page when invoice is created' do
        order.update(xero_id: 'abc123')

        visit admin_orders_path
        click_link order.contact.name

        expect(current_path).to eq(admin_order_path(order))
      end
    end
  end
end
