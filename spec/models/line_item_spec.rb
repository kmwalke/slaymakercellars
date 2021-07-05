require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:order) { Order.create(contact: contact, delivery_date: 1.week.from_now) }

  it 'should require an order' do
    expect(LineItem.create(order_id: nil).errors).to have_key(:order)
  end

  it 'should require a product' do
    expect(LineItem.create(product_id: nil).errors).to have_key(:product)
  end

  it 'should require a quantity' do
    expect(LineItem.create(quantity: nil).errors).to have_key(:quantity)
  end
end
