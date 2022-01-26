require 'rails_helper'

RSpec.describe Town, type: :model do
  it 'should require a name' do
    expect(Town.create(name: '').errors).to have_key(:name)
  end

  it 'should require a state' do
    expect(Town.create(state_id: '').errors).to have_key(:state_id)
  end

  it 'should require name/state uniqueness' do
    town = FactoryBot.create(:town)
    expect { FactoryBot.create(:town, name: town.name, state: town.state) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should allow duplicate names in other states' do
    town = FactoryBot.create(:town)
    expect { FactoryBot.create(:town, name: town.name) }.not_to raise_error(ActiveRecord::RecordInvalid)
  end
end
