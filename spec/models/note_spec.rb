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

  it 'should be unresolved on creation' do
    note = Note.create(contact: contact, body: 'this is a note')
    expect(note.resolved?).to eq(false)
  end

  it 'should be resolved' do
    note = Note.create(contact: contact, body: 'this is a note', resolved_at: DateTime.now)
    expect(note.resolved?).to eq(true)
  end
end
