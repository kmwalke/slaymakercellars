require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'should require a name' do
    expect(Product.create(name: '').errors).to have_key(:name)
  end

  it 'should require a price_point' do
    expect(Product.create(price_point: nil).errors).to have_key(:price_point)
  end
end
