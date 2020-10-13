require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) { Product.create(name: 'traditional') }

  it 'should require a name' do
    expect(Product.create(name: '').errors).to have_key(:name)
  end

  it 'should require a unique name' do
    expect(Product.create(name: 'traditional').errors).to have_key(:name)
  end

  it 'should require a sweetness' do
    expect(Product.create(sweetness: '').errors).to have_key(:sweetness)
  end

  it 'should require a bottle image' do
    expect(Product.create(bottle_image: '').errors).to have_key(:bottle_image)
  end
end
