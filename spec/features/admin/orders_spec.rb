require 'rails_helper'

describe 'Admin::Orders' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit admin_orders_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_orders_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    before do
      login_as_admin
    end

    let!(:order) { create(:order) }

    it 'opens Admin::Orders' do
      visit admin_orders_path

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(page).to have_content('Orders')
    end

    it 'creates an order' do
      visit admin_orders_path

      first(:link, 'New Order').click
      expect(page).to have_current_path(new_admin_order_path, ignore_query: true)

      fill_in 'Contact', with: order.contact.name
      fill_in 'Delivery date', with: order.delivery_date

      click_button 'Save'
      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(page).to have_content('created')
    end

    it 'updates an order' do
      new_date = order.delivery_date + 1
      visit admin_orders_path

      click_link order.contact.name
      expect(page).to have_current_path(edit_admin_order_path(order.id), ignore_query: true)

      fill_in 'Delivery date', with: new_date

      first(:button, 'Update').click
      expect(page).to have_current_path(edit_admin_order_path(order.id), ignore_query: true)
      expect(Order.find_by(id: order.id).delivery_date).to eq(new_date)

      fill_in 'Delivery date', with: new_date + 1
      first(:button, 'Save & Finish').click
      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(Order.find_by(id: order.id).delivery_date).to eq(new_date + 1)
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

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(Order.find_by(id: order.id).deleted_at).not_to be_nil
    end

    it 'deletes an order from order page' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'Void'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(Order.find_by(id: order.id).deleted_at).not_to be_nil
    end

    it 'delivers an order from index' do
      visit admin_orders_path

      click_link "deliver_#{order.id}"

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(Order.find_by(id: order.id).fulfilled_on).not_to be_nil
    end

    it 'delivers an order from order page' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'Mark Delivered'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(Order.find_by(id: order.id).fulfilled_on).not_to be_nil
    end

    it 'shows delivered orders' do
      order.fulfill
      visit admin_orders_path

      click_link 'Delivered Orders'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      expect(page).to have_content(order.id)
    end

    it 'shows a delivered order' do
      order.fulfill
      visit edit_admin_order_path(order.id)

      expect(page).to have_current_path(admin_order_path(order.id), ignore_query: true)

      expect(page).to have_content(order.id)
    end

    it 'undelivers an order' do
      order.fulfill

      visit admin_orders_path
      click_link 'Delivered Orders'
      click_link order.contact.name
      click_link 'Undeliver'

      expect(page).to have_current_path(edit_admin_order_path(order.id), ignore_query: true)
      expect(Order.find_by(id: order.id).fulfilled_on).to be_nil
    end

    it 'views all orders by a contact' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'View all orders'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
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

      select admin.name, from: 'order_assigned_to_id'
      first(:button, 'Update').click

      expect(order.reload.assigned_to).to eq(admin)
    end

    describe 'sync' do
      it 'shows xero sync errors' do
        message = 'bad email'
        order.xero_sync_errors << XeroSyncError.new(message:)

        visit edit_admin_order_path(order)

        expect(page).to have_content(message)
      end

      it 'does not show xero link for unsynced on edit' do
        visit edit_admin_order_path(order)

        expect(page).not_to have_content('Open Invoice')
        expect(page).to have_content('Create Invoice')
      end

      it 'does not show xero link for unsynced on show' do
        visit admin_order_path(order)

        expect(page).not_to have_content('Open Invoice')
        expect(page).to have_content('Create Invoice')
      end

      it 'shows xero link for synced' do
        order.update(xero_id: 'abc123')
        visit admin_order_path(order)

        expect(page).to have_content('Open Invoice')
        expect(page).not_to have_content('Create Invoice')
      end

      it 'does not allow editing of orders with an invoice' do
        order.update(xero_id: 'abc123')

        visit edit_admin_order_path(order)

        expect(page).to have_current_path(admin_order_path(order), ignore_query: true)
      end

      it 'links to show page when invoice is created' do
        order.update(xero_id: 'abc123')

        visit admin_orders_path
        click_link order.contact.name

        expect(page).to have_current_path(admin_order_path(order), ignore_query: true)
      end
    end
  end
end
