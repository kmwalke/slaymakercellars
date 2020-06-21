require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'should require a name' do
    expect(Contact.create(name: '').errors).to have_key(:name)
  end

  it 'should require a town' do
    expect(Contact.create(town_id: '').errors).to have_key(:town_id)
  end
end
