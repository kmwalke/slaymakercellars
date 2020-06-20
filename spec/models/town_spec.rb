require 'rails_helper'

RSpec.describe Town, type: :model do
  it 'should require a name' do
    expect(Town.create(name: '').errors).to have_key(:name)
  end
end
