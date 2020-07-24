require 'rails_helper'

RSpec.describe Note, type: :model do
  it 'should require content' do
    expect(Note.create(content: '').errors).to have_key(:content)
  end

  it 'should require a contact' do
    expect(Note.create(contact_id: '').errors).to have_key(:contact_id)
  end

  it 'should require a created_by user' do
    expect(Note.create(created_by_id: '').errors).to have_key(:created_by_id)
  end
end
