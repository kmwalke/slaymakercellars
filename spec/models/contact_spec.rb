require 'rails_helper'

RSpec.describe Contact, type: :model do
  let!(:contact) { FactoryBot.create(:contact) }
  let(:deleted_contact) { FactoryBot.create(:contact, deleted_at: DateTime.now) }
  let!(:user) { FactoryBot.create(:admin) }

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

  describe 'last_contacted' do
    it 'should show nil last contacted for new contacts' do
      expect(contact.last_contacted).to be_nil
    end

    it 'should use note date for last contacted' do
      FactoryBot.create(:note, contact:, created_at: 5.days.ago)
      note2 = FactoryBot.create(:note, contact:)

      expect(contact.last_contacted).to eq(note2.created_at)
    end

    it 'should use order date for last contacted when order newer' do
      FactoryBot.create(:note, contact:, created_at: 14.days.ago)
      order = FactoryBot.create(:order, contact:, created_at: 5.days.ago)
      FactoryBot.create(:note, contact:)

      expect(contact.last_contacted).to eq(order.created_at)
    end

    it 'should use note date for last contacted when note newer' do
      FactoryBot.create(:note, contact:, created_at: 5.days.ago)
      FactoryBot.create(:order, contact:, created_at: 14.days.ago)
      note2 = FactoryBot.create(:note, contact:)

      expect(contact.last_contacted).to eq(note2.created_at)
    end

    it 'should use create order date for last contacted' do
      order = FactoryBot.create(:order, contact:, created_at: 14.days.ago)

      expect(contact.last_contacted).to eq(order.created_at)
    end

    it 'should use order date for last contacted' do
      order = FactoryBot.create(:order, contact:, fulfilled_on: 14.days.ago)

      expect(contact.last_contacted).to eq(order.fulfilled_on)
    end
  end

  it 'should get last order fulfilled date' do
    FactoryBot.create(:order, contact:, fulfilled_on: 14.days.ago)
    last_order_date = FactoryBot.create(:order, contact:, fulfilled_on: 7.days.ago).fulfilled_on

    expect(contact.last_order_date).to eq(last_order_date)
  end

  it 'should get todays date on unfulfilled orders' do
    FactoryBot.create(:order, contact:)
    FactoryBot.create(:order, contact:, fulfilled_on: 7.days.ago).fulfilled_on

    expect(contact.last_order_date).to eq(Date.today)
  end

  it 'should get nil on contacts with no orders' do
    expect(contact.last_order_date).to eq(nil)
  end

  it 'should repeat last order' do
    FactoryBot.create(:order, contact:)

    expect(contact.repeat_last_order).to be_kind_of(Order)
  end

  it 'should not repeat last order for new contacts' do
    expect(contact.repeat_last_order).to be_nil
  end

  it 'should return google maps link' do
    contact.update(address: '2036 virginia st')
    expect(contact.reload.google_maps_url)
      .to eq(
            "https://www.google.com/maps?q=2036+virginia+st,+#{contact.town.name},+#{contact.town.state.abbreviation}"
          )
  end

  it 'should return google maps link with no address' do
    contact.update(name: 'slaymaker cellars', address: '')
    expect(contact.reload.google_maps_url)
      .to eq(
            "https://www.google.com/maps?q=slaymaker+cellars,+#{contact.town.name},+#{contact.town.state.abbreviation}"
          )
  end
end
