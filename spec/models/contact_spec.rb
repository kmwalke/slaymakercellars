require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'should require a name' do
    expect(Contact.create(name: '').errors).to have_key(:name)
  end

  it 'should require a unique name' do
    Contact.create(name: 'john', town: Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')))
    expect(Contact.create(name: 'john').errors).to have_key(:name)
  end

  it 'should require a town' do
    expect(Contact.create(town_id: '').errors).to have_key(:town_id)
  end
end
