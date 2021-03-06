require 'rails_helper'

RSpec.describe Contact, type: :model do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let(:deleted_contact) { Contact.create(name: 'deleted', town: town, deleted_at: DateTime.now) }

  it 'should require a name' do
    expect(Contact.create(name: '').errors).to have_key(:name)
  end

  it 'should require a unique name' do
    expect(Contact.create(name: 'john', town: town).errors).to have_key(:name)
  end

  it 'should require a town' do
    expect(Contact.create(town_id: '').errors).to have_key(:town_id)
  end

  it 'should require a valid url' do
    expect(Contact.create(url: 'not a url').errors).to have_key(:url)
  end

  it 'should require a full url' do
    expect(Contact.create(url: 'www.google.com').errors).to have_key(:url)
  end

  it 'should allow a full url' do
    expect(Contact.create(url: 'http://www.google.com').errors).not_to have_key(:url)
  end

  it 'should soft delete' do
    expect(contact.destroy).to eq('archived')
    expect(contact.reload.deleted_at).to be_a(ActiveSupport::TimeWithZone)
  end

  it 'should soft undelete' do
    deleted_contact.undestroy

    expect(deleted_contact.reload.deleted_at).to be_nil
  end

  it 'should hard delete' do
    expect(deleted_contact.destroy).to eq('destroyed')
    expect { deleted_contact.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'display' do
    it 'should select active by default' do
      show, contacts, title = Contact.display

      expect(contacts).to include(contact)
      expect(contacts).not_to include(deleted_contact)
      expect(show).to eq('active')
      expect(title).to eq('Active Contacts')
    end

    it 'should select active' do
      show, contacts, title = Contact.display('active')

      expect(contacts).to include(contact)
      expect(contacts).not_to include(deleted_contact)
      expect(show).to eq('active')
      expect(title).to eq('Active Contacts')
    end

    it 'should select inactive' do
      show, contacts, title = Contact.display('inactive')

      expect(contacts).to include(deleted_contact)
      expect(contacts).not_to include(contact)
      expect(show).to eq('inactive')
      expect(title).to eq('Deleted Contacts')
    end
  end
end
