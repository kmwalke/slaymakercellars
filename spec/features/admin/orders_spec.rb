require 'rails_helper'

describe 'Admin::Orders', type: :feature do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:user) { User.create(name: 'name1', email: 'name1@place.com', password: '123') }
  let!(:order) { Order.create(contact: contact, delivery_date: 1.week.from_now, created_by: user) }

  it 'opens Admin::Orders' do
    login
    visit admin_orders_path

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content('Orders')
  end

  it 'creates an order' do
    login
    visit admin_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_admin_order_path)

    select order.contact.name, from: 'order_contact_id'
    fill_in 'Delivery date', with: order.delivery_date

    click_button 'Save'
    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content('created')
  end

  it 'updates an order' do
    login
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
    login
    visit edit_admin_order_path(order.id)

    expect(page).to have_content('Created by')
    expect(page).to have_content(user.name)
  end

  it 'records users updating orders' do
    user2 = login

    visit edit_admin_order_path(order.id)
    new_date = order.delivery_date + 1
    fill_in 'Delivery date', with: new_date

    first(:button, 'Update').click

    visit edit_admin_order_path(order.id)
    expect(page).to have_content('Updated by')
    expect(page).to have_content(user2.name)
  end

  it 'deletes an order from index' do
    login
    visit admin_orders_path

    click_link "void_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order.id).deleted_at).to_not be_nil
  end

  it 'deletes an order from order page' do
    login
    visit admin_orders_path

    click_link order.contact.name
    click_link 'Void'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order.id).deleted_at).to_not be_nil
  end

  it 'delivers an order from index' do
    login
    visit admin_orders_path

    click_link "deliver_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order.id).fulfilled_on).not_to eq(nil)
  end

  it 'delivers an order from order page' do
    login
    visit admin_orders_path

    click_link order.contact.name
    click_link 'Mark Delivered'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order.id).fulfilled_on).not_to eq(nil)
  end

  it 'shows delivered orders' do
    order.fulfill
    login
    visit admin_orders_path

    click_link 'Delivered Orders'

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content(order.id)
  end

  it 'shows a delivered order' do
    login
    order.fulfill
    visit edit_admin_order_path(order.id)

    expect(current_path).to eq(admin_order_path(order.id))

    expect(page).to have_content(order.id)
  end

  it 'undelivers an order' do
    login
    order.fulfill

    visit admin_orders_path
    click_link 'Delivered Orders'
    click_link order.contact.name
    click_link 'Undeliver'

    expect(current_path).to eq(edit_admin_order_path(order.id))
    expect(Order.find_by_id(order.id).fulfilled_on).to eq(nil)
  end

  it 'views all orders by a contact' do
    login
    visit admin_orders_path

    click_link order.contact.name
    click_link 'View all orders'

    expect(current_path).to eq(admin_orders_path)
  end

  it 'shows late orders' do
    login
    order.update(delivery_date: Date.yesterday)

    visit admin_orders_path
    click_on 'Late Orders'

    expect(page).to have_content(order.contact.name)
    expect(page).to have_content(order.id)
  end
end
