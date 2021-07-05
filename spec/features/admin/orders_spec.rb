require 'rails_helper'

describe 'Admin::Orders', type: :feature do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:order) { Order.create(contact: contact, delivery_date: 1.week.from_now) }

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

    fill_in 'Contact.name', with: order.contact.name
    fill_in 'Delivery date', with: order.delivery_date

    click_button 'Save'
    expect(current_path).to eq(edit_admin_order_path(order.id + 1))
    expect(page).to have_content('created')
  end

  it 'updates an order' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    new_date = order.delivery_date + 1
    visit admin_orders_path

    click_link order.contact.name
    expect(current_path).to eq(edit_admin_order_path(order_id))

    fill_in 'Delivery date', with: new_date

    first(:button, 'Update').click
    expect(current_path).to eq(edit_admin_order_path(order_id))
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date)

    fill_in 'Delivery date', with: new_date + 1
    first(:button, 'Save & Finish').click
    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).delivery_date).to eq(new_date + 1)
  end

  it 'records users creating orders' do
    user  = login
    visit edit_admin_order_path(order.id)

    expect(page).to have_content('Created by')
    expect(page).to have_content(user.name)
  end

  it 'records users updating orders' do
    user  = login

    visit edit_admin_order_path(order.id)
    new_date = order.delivery_date + 1
    fill_in 'Delivery date', with: new_date

    first(:button, 'Update').click

    visit edit_admin_order_path(order.id)
    expect(page).to have_content('Updated by')
    expect(page).to have_content(user.name)
  end

  it 'deletes an order from index' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link "void_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'deletes an order from order page' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link order.contact.name
    click_link 'Void'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id)).to eq(nil)
  end

  it 'delivers an order from index' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link "deliver_#{order.id}"

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).fulfilled_on).not_to eq(nil)
  end

  it 'delivers an order from order page' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_orders_path

    click_link order.contact.name
    click_link 'Mark Delivered'

    expect(current_path).to eq(admin_orders_path)
    expect(Order.find_by_id(order_id).fulfilled_on).not_to eq(nil)
  end

  it 'shows delivered orders' do
    login
    order    = FactoryBot.create(:order, fulfilled_on: Date.yesterday)
    order_id = order.id
    visit admin_orders_path

    click_link 'Delivered Orders'

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content(order_id)
  end

  it 'shows a delivered order' do
    login
    order    = FactoryBot.create(:order, fulfilled_on: Date.yesterday)
    order_id = order.id
    visit edit_admin_order_path(order_id)

    expect(current_path).to eq(admin_order_path(order_id))

    expect(page).to have_content(order_id)
  end

  it 'edits an undelivered order' do
    login
    order    = FactoryBot.create(:order)
    order_id = order.id
    visit admin_order_path(order_id)

    expect(current_path).to eq(edit_admin_order_path(order_id))

    expect(page).to have_content(order_id)
  end

  it 'undelivers an order' do
    login
    order    = FactoryBot.create(:order, fulfilled_on: Date.yesterday)
    order_id = order.id

    visit admin_orders_path
    click_link 'Delivered Orders'
    click_link order.contact.name
    click_link 'Undeliver'

    expect(current_path).to eq(edit_admin_order_path(order_id))
    expect(Order.find_by_id(order_id).fulfilled_on).to eq(nil)
  end

  it 'views all orders by a contact' do
    login
    visit admin_orders_path

    click_link order.contact.name
    click_link 'View all orders'

    expect(current_path).to eq(admin_orders_path)
  end

  it 'creates some line_items' do
    login
    visit admin_orders_path

    first(:link, 'New Order').click
    expect(current_path).to eq(new_admin_order_path)

    fill_in 'Contact.name', with: order.contact.name
    fill_in 'Delivery date', with: order.delivery_date

    click_link 'add line item'
    FactoryBot.create(:line_item, order_id: order.id)
    FactoryBot.create(:line_item, order_id: order.id)

    click_button 'Save'
    expect(current_path).to eq(edit_admin_order_path(order.id + 1))
    expect(order.line_items.count).to eq 2
    expect(page).to have_content('created')
  end

  it 'shows late orders' do
    login

    visit admin_orders_path
    click_on 'Late Orders'

    expect(page).to have_content(order.contact.name)
    expect(page).to have_content(order.id)
  end
end
