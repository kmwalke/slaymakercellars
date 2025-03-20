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

    describe 'opens Admin::Orders' do
      before do
        visit admin_orders_path
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'shows the title' do
        expect(page).to have_content('Orders')
      end
    end

    describe 'creates an order' do
      before do
        visit admin_orders_path

        first(:link, 'New Order').click
      end

      it 'renders the new order page' do
        expect(page).to have_current_path(new_admin_order_path, ignore_query: true)
      end

      describe 'new order form' do
        before do
          visit admin_orders_path

          first(:link, 'New Order').click
          fill_in 'Contact', with: order.contact.name
          fill_in 'Delivery date', with: order.delivery_date

          click_button 'Save'
        end

        it 'renders the index page' do
          expect(page).to have_current_path(admin_orders_path, ignore_query: true)
        end

        it 'creates the order' do
          expect(page).to have_content('created')
        end
      end
    end

    describe 'updates an order' do
      before do
        visit admin_orders_path

        click_link order.contact.name
      end

      it 'renders the edit order page' do
        expect(page).to have_current_path(edit_admin_order_path(order.id), ignore_query: true)
      end

      describe 'update order form' do
        let!(:new_date) { order.delivery_date + 1 }

        before do
          visit admin_orders_path

          click_link order.contact.name

          fill_in 'Delivery date', with: new_date

          first(:button, 'Update').click

          fill_in 'Delivery date', with: new_date + 1
          first(:button, 'Save & Finish').click
        end

        it 'renders the index page' do
          expect(page).to have_current_path(admin_orders_path, ignore_query: true)
        end

        it 'shows the new order id' do
          expect(page.body).to include("<strong>#{order.id}</strong>")
        end

        it 'saves the new order date' do
          expect(Order.find_by(id: order.id).delivery_date).to eq(new_date + 1)
        end
      end
    end

    it 'records users creating orders' do
      visit edit_admin_order_path(order.id)

      expect(page).to have_content("Created by #{order.created_by.name}")
    end

    describe 'records users updating orders' do
      let!(:user2) { login_as_admin }

      before do
        visit edit_admin_order_path(order.id)
        fill_in 'Delivery date', with: order.delivery_date + 1

        first(:button, 'Update').click

        visit edit_admin_order_path(order.id)
      end

      it 'records user when updating orders' do
        expect(page).to have_content("Updated by #{user2.name}")
      end
    end

    describe 'deletes an order from index' do
      before do
        visit admin_orders_path

        click_link "void_#{order.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'archives the order' do
        expect(Order.find_by(id: order.id).deleted_at).not_to be_nil
      end

      it 'does not display the archived order' do
        expect(page.body).not_to include("<strong>#{order.id}</strong>")
      end
    end

    describe 'deletes an order from order page' do
      before do
        visit admin_orders_path

        click_link order.contact.name
        click_link 'Void'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'archives the order' do
        expect(Order.find_by(id: order.id).deleted_at).not_to be_nil
      end

      it 'does not display the archived order' do
        expect(page.body).not_to include("<strong>#{order.id}</strong>")
      end
    end

    describe 'delivers an order from index' do
      before do
        visit admin_orders_path

        click_link "deliver_#{order.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'delivers the order' do
        expect(Order.find_by(id: order.id).fulfilled_on).not_to be_nil
      end
    end

    describe 'delivers an order from order page' do
      before do
        visit admin_orders_path

        click_link order.contact.name
        click_link 'Mark Delivered'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'delivers the order' do
        expect(Order.find_by(id: order.id).fulfilled_on).not_to be_nil
      end
    end

    describe 'shows delivered orders' do
      before do
        order.fulfill
        visit admin_orders_path

        click_link 'Delivered Orders'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_orders_path, ignore_query: true)
      end

      it 'shows the delivered order' do
        expect(page.body).to include("<strong>#{order.id}</strong>")
      end

      it 'does not show the delivered order on the main page' do
        visit admin_orders_path

        expect(page.body).not_to include("<strong>#{order.id}</strong>")
      end
    end

    it 'shows a delivered order' do
      order.fulfill
      visit edit_admin_order_path(order.id)

      expect(page).to have_current_path(admin_order_path(order.id), ignore_query: true)
    end

    describe 'undelivers an order' do
      before do
        order.fulfill

        visit admin_orders_path
        click_link 'Delivered Orders'
        click_link order.contact.name
        click_link 'Undeliver'
      end

      it 'renders the edit page' do
        expect(page).to have_current_path(edit_admin_order_path(order.id), ignore_query: true)
      end

      it 'undelivers the order' do
        expect(Order.find_by(id: order.id).fulfilled_on).to be_nil
      end

      it 'shows the order id on the main page' do
        visit admin_orders_path
        expect(page.body).to include("<strong>#{order.id}</strong>")
      end
    end

    it 'views all orders by a contact' do
      visit admin_orders_path

      click_link order.contact.name
      click_link 'View all orders'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
    end

    describe 'shows late orders' do
      before do
        order.update(delivery_date: Date.yesterday)

        visit admin_orders_path
        click_link 'Late Orders'
      end

      it 'shows the order contact name' do
        expect(page.body).to include("\">#{order.contact.name}</a>")
      end

      it 'shows the order id' do
        expect(page.body).to include("<strong>#{order.id}</strong>")
      end

      it 'shows the order id on the main page' do
        visit admin_orders_path
        expect(page.body).to include("<strong>#{order.id}</strong>")
      end
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

      describe 'does not show xero link for unsynced on edit' do
        before do
          visit edit_admin_order_path(order)
        end

        it 'does not show open invoice link' do
          expect(page).to have_no_content('Open Invoice')
        end

        it 'shows create xero invoice link' do
          expect(page).to have_content('Create Invoice')
        end
      end

      describe 'does not show xero link for unsynced on show' do
        before do
          visit admin_order_path(order)
        end

        it 'does not show open invoice link' do
          expect(page).to have_no_content('Open Invoice')
        end

        it 'shows create xero invoice link' do
          expect(page).to have_content('Create Invoice')
        end
      end

      describe 'shows xero link for synced' do
        before do
          order.update(xero_id: 'abc123')
          visit admin_order_path(order)
        end

        it 'shows the open invoice link' do
          expect(page).to have_content('Open Invoice')
        end

        it 'does not show the create invoice link' do
          expect(page).to have_no_content('Create Invoice')
        end
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
