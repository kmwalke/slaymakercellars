require 'rails_helper'

RSpec.describe Award, type: :model do
  it 'should require a name' do
    expect(Award.create(name: '').errors).to have_key(:name)
  end

  it 'should require a product' do
    expect(Award.create(product_id: '').errors).to have_key(:product_id)
  end
end
