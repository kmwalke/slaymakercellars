require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:user) { User.create(email: 'email', name: 'name', password: '123') }
  let!(:order) { Order.create(contact: contact, delivery_date: 1.week.from_now, created_by: user) }

  it 'should require an order' do
    expect(LineItem.create(order_id: nil).errors).to have_key(:order)
  end

  it 'should require a product' do
    expect(LineItem.create(product_id: nil).errors).to have_key(:product)
  end

  it 'should require a quantity' do
    expect(LineItem.create(quantity: nil).errors).to have_key(:quantity)
  end

  describe 'methods' do
    let!(:product) do
      Product.create(name: 'product_1', price_point: 14, description: 'This is the description',
                     category: Product::CATEGORIES.last, xero_code: 'duct_1')
    end
    let!(:partial_line_item) { LineItem.create(quantity: 1, order: order, product: product) }
    let!(:case_line_item) { LineItem.create(quantity: product.case_size, order: order, product: product) }

    it 'should respect case pricing' do
      expect(case_line_item.price_point < product.price_point).to be true
    end

    it 'should respect special customer pricing' do
      special_contact = Contact.create(name: 'john', town: town, always_gets_case_deal: true)
      order.update(contact: special_contact)

      expect(partial_line_item.price_point < product.price_point).to be true
    end

    it 'should respect non-case pricing' do
      expect(partial_line_item.price_point).to eq(product.price_point)
    end
  end
end
