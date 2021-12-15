require 'rails_helper'

describe 'Admin::Fulfillment', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit admin_fulfillment_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged out' do
    let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
    let!(:contact) { Contact.create(name: 'john', town: town) }
    let!(:user) { User.create(email: 'email', name: 'name', password: '123') }
    let!(:product) do
      Product.create(name: 'product_1', price_point: 14, description: 'This is the description',
                     category: Product::CATEGORIES.last, xero_code: 'duct_1')
    end
    let!(:product2) do
      Product.create(name: 'product_2', price_point: 14, description: 'This is the description',
                     category: Product::CATEGORIES.last, xero_code: 'duct_2')
    end
    let!(:order) { Order.create(contact: contact, delivery_date: Date.current, created_by: user) }
    let!(:case_line_item) { LineItem.create(quantity: product.case_size, order: order, product: product) }
    let!(:order2) { Order.create(contact: contact, delivery_date: Date.current + 1, created_by: user) }
    let!(:case_line_item2) { LineItem.create(quantity: product.case_size, order: order2, product: product) }

    it 'opens Admin::Fulfillment' do
      login
      visit admin_fulfillment_path

      expect(current_path).to eq(admin_fulfillment_path)
      expect(page).to have_content('Total')
    end
  end
end