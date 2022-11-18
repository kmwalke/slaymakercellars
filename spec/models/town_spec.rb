require 'rails_helper'

RSpec.describe Town do
  it 'requires a name' do
    expect(described_class.create(name: '').errors).to have_key(:name)
  end

  it 'requires a state' do
    expect(described_class.create(state_id: '').errors).to have_key(:state_id)
  end

  it 'requires name/state uniqueness' do
    town = create(:town)
    expect do
      create(:town, name: town.name, state: town.state)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'allows duplicate names in other states' do
    town = create(:town)
    expect { create(:town, name: town.name) }.not_to raise_error
  end
end
