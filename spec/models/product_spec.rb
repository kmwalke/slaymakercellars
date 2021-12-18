require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'should require a name' do
    expect(Product.create(name: '').errors).to have_key(:name)
  end

  it 'should require a unique name' do
    product = FactoryBot.create(:product)
    expect { FactoryBot.create(:product, name: product.name) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a xero id' do
    expect { FactoryBot.create(:product, xero_code: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a unique xero id' do
    product = FactoryBot.create(:product)
    expect { FactoryBot.create(:product, xero_code: product.xero_code) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a price point' do
    expect { FactoryBot.create(:product, price_point: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
