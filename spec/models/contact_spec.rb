require 'rails_helper'

RSpec.describe Contact do
  let!(:contact) { create(:contact) }
  let(:deleted_contact) { create(:contact, deleted_at: DateTime.now) }
  let!(:user) { create(:admin) }

  it 'requires a name' do
    expect { create(:contact, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a unique name' do
    expect { create(:contact, name: contact.name) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a town' do
    expect { create(:contact, town: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires an address' do
    expect { create(:contact, address: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a non-blank address' do
    expect { create(:contact, address: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a valid url' do
    expect { create(:contact, url: 'not a url') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a full url' do
    expect { create(:contact, url: 'www.google.com') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot have negative kegs' do
    expect { FactoryBot.create(:contact, num_kegs: -1) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'allows a full url' do
    expect { create(:contact, url: 'http://www.google.com') }.not_to raise_error
  end

  it 'softs delete' do
    expect(contact.destroy).to eq('archived')
    expect(contact.reload.deleted_at).to be_a(ActiveSupport::TimeWithZone)
  end

  it 'softs undelete' do
    deleted_contact.undestroy

    expect(deleted_contact.reload.deleted_at).to be_nil
  end

  it 'hards delete' do
    expect(deleted_contact.destroy).to eq('destroyed')
    expect { deleted_contact.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'last_contacted' do
    it 'shows nil last contacted for new contacts' do
      expect(contact.last_contacted).to be_nil
    end

    it 'uses note date for last contacted' do
      create(:note, contact:, created_at: 5.days.ago)
      note2 = create(:note, contact:)

      expect(contact.last_contacted).to eq(note2.created_at.to_date)
    end

    it 'uses order date for last contacted when order newer' do
      create(:note, contact:, created_at: 14.days.ago)
      order = create(:order, contact:, created_at: 5.days.ago)

      expect(contact.last_contacted).to eq(order.created_at.to_date)
    end

    it 'uses note date for last contacted when note newer' do
      create(:note, contact:, created_at: 5.days.ago)
      create(:order, contact:, created_at: 14.days.ago)
      note2 = create(:note, contact:)

      expect(contact.last_contacted).to eq(note2.created_at.to_date)
    end

    it 'uses create order date for last contacted' do
      order = create(:order, contact:, created_at: 14.days.ago)

      expect(contact.last_contacted).to eq(order.created_at.to_date)
    end

    it 'uses order date for last contacted' do
      order = create(:order, contact:, fulfilled_on: 14.days.ago)

      expect(contact.last_contacted).to eq(order.fulfilled_on)
    end
  end

  it 'gets last order fulfilled date' do
    create(:order, contact:, fulfilled_on: 14.days.ago)
    last_order_date = create(:order, contact:, fulfilled_on: 7.days.ago).fulfilled_on

    expect(contact.last_fulfilled_order_date).to eq(last_order_date)
  end

  it 'gets todays date on unfulfilled orders' do
    create(:order, contact:)
    create(:order, contact:, fulfilled_on: 7.days.ago)

    expect(contact.last_fulfilled_order_date).to eq(Date.today)
  end

  it 'gets nil on contacts with no orders' do
    expect(contact.last_fulfilled_order_date).to be_nil
  end

  it 'repeats last order' do
    create(:order, contact:)

    expect(contact.repeat_last_order).to be_a(Order)
  end

  it 'does not repeat last order for new contacts' do
    expect(contact.repeat_last_order).to be_nil
  end
end
