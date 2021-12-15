require 'rails_helper'

RSpec.describe FulfillmentPlan, type: :model do
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
  let!(:fulfillment_plan) { FulfillmentPlan.new }

  describe 'methods' do
    it 'lists products' do
      expect(fulfillment_plan.product_names).to eq([product.name, product2.name])
    end

    it 'returns total amount' do
      expect(fulfillment_plan.total_amount(product.name)).to eq(product.case_size * 2)
    end

    it 'returns amount for a day' do
      expect(fulfillment_plan.amount(product.name, Date.current)).to eq(product.case_size)
    end
  end
end
