require 'rails_helper'

RSpec.describe Town, type: :model do
  it 'should require a name' do
    expect(Town.create(name: '').errors).to have_key(:name)
  end

  it 'should require a state' do
    expect(Town.create(state_id: '').errors).to have_key(:state_id)
  end
end
