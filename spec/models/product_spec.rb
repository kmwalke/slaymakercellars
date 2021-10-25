require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) do
    Product.create(name: 'product_1', price_point: 14, description: 'This is the description',
                   category: Product::CATEGORIES.last, xero_id: 'duct_1')
  end

  it 'should require a name' do
    expect(Product.create(name: '').errors).to have_key(:name)
  end

  it 'should require a unique name' do
    expect(Product.create(name: 'product_1').errors).to have_key(:name)
  end

  it 'should require a xero id' do
    expect(Product.create(xero_id: '').errors).to have_key(:xero_id)
  end

  it 'should require a unique xero id' do
    expect(Product.create(xero_id: 'duct_1').errors).to have_key(:xero_id)
  end

  it 'should require a price point' do
    expect(Product.create(price_point: '').errors).to have_key(:price_point)
  end
end
