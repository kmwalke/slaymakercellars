require 'rails_helper'

RSpec.describe Contact, type: :model do
  let!(:contact) { FactoryBot.create(:contact) }
  let(:deleted_contact) { FactoryBot.create(:contact, deleted_at: DateTime.now) }
  let!(:user) { FactoryBot.create(:user) }

  it 'should require a name' do
    expect { FactoryBot.create(:contact, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a unique name' do
    expect { FactoryBot.create(:contact, name: contact.name) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a town' do
    expect { FactoryBot.create(:contact, town: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a valid url' do
    expect { FactoryBot.create(:contact, url: 'not a url') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a full url' do
    expect { FactoryBot.create(:contact, url: 'www.google.com') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should allow a full url' do
    expect { FactoryBot.create(:contact, url: 'http://www.google.com') }.not_to raise_error
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

  it 'should show last contacted' do
    FactoryBot.create(:note, contact: contact, created_at: 5.days.ago)
    note2 = FactoryBot.create(:note, contact: contact)

    expect(contact.last_contacted).to eq(note2.created_at)
  end

  it 'should get last order fulfilled date' do
    FactoryBot.create(:order, contact: contact, fulfilled_on: 14.days.ago)
    last_order_date = FactoryBot.create(:order, contact: contact, fulfilled_on: 7.days.ago).fulfilled_on

    expect(contact.last_order_date).to eq(last_order_date)
  end

  it 'should get todays date on unfulfilled orders' do
    FactoryBot.create(:order, contact: contact)
    FactoryBot.create(:order, contact: contact, fulfilled_on: 7.days.ago).fulfilled_on

    expect(contact.last_order_date).to eq(Date.today)
  end

  it 'should get nil on contacts with no orders' do
    expect(contact.last_order_date).to eq(nil)
  end

  it 'should repeat last order' do
    FactoryBot.create(:order, contact: contact)

    expect(contact.repeat_last_order).to be_kind_of(Order)
  end

  it 'should not repeat last order for new contacts' do
    expect(contact.repeat_last_order).to be_nil
  end

  it 'should return google maps link' do
    contact.update(address: '2036 virginia st, idaho springs, co')
    expect(contact.reload.google_maps_url).to eq('https://www.google.com/maps?q=2036+virginia+st,+idaho+springs,+co')
  end

  it 'should return google maps link with no address' do
    contact.update(name: 'slaymaker cellars', address: '')
    expect(contact.reload.google_maps_url)
      .to eq(
            "https://www.google.com/maps?q=slaymaker+cellars,+#{contact.town.name},+#{contact.town.state.abbreviation}"
          )
  end
end
