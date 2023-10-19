require 'rails_helper'

RSpec.describe SalesRep do
  it 'requires a name' do
    expect(described_class.create(name: '').errors).to have_key(:name)
  end

  it 'requires a contact' do
    expect(described_class.create(contact_id: '').errors).to have_key(:contact_id)
  end
end
