require 'rails_helper'

RSpec.describe Note, type: :model do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }

  it 'should require a body' do
    expect(Note.create(body: '').errors).to have_key(:body)
  end

  it 'should require a contact' do
    expect(Note.create(contact_id: '').errors).to have_key(:contact_id)
  end
end
