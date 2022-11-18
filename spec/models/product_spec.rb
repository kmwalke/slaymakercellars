require 'rails_helper'

RSpec.describe Product do
  it 'requires a name' do
    expect(described_class.create(name: '').errors).to have_key(:name)
  end

  it 'requires a unique name' do
    product = create(:product)
    expect { create(:product, name: product.name) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a xero id' do
    expect { create(:product, xero_code: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a unique xero id' do
    product = create(:product)
    expect { create(:product, xero_code: product.xero_code) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a price point' do
    expect { create(:product, price_point: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
