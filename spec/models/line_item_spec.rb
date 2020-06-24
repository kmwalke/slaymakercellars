require 'rails_helper'

RSpec.describe LineItem, type: :model do
  it 'should require a quantity' do
    expect(LineItem.create(quantity: '').errors).to have_key(:quantity)
  end

  it 'should require a price' do
    expect(LineItem.create(price: '').errors).to have_key(:price)
  end

  it 'should require a product' do
    expect(LineItem.create(product_id: '').errors).to have_key(:product_id)
  end

  it 'should require a PO' do
    expect(LineItem.create(purchase_order_id: '').errors).to have_key(:purchase_order_id)
  end
end
