require 'rails_helper'

RSpec.describe Order do
  let(:user) { create(:admin) }
  let!(:order) { create(:order) }

  it 'requires a contact' do
    expect { create(:order, contact_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a delivery date' do
    expect { create(:order, delivery_date: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'defaults to undelivered' do
    expect(order.delivered).to be(false)
  end

  it 'has a contact_name' do
    expect(order.contact_name).to eq(order.contact.name)
  end

  it 'updates contact by name' do
    new_contact = create(:contact, name: 'new_conact')
    order.contact_name = new_contact.name
    order.save

    expect(order.reload.contact).to eq(new_contact)
  end

  it 'checks if fulfilled' do
    expect(order.fulfilled?).to be(false)
  end

  it 'fulfills an order' do
    order.fulfill
    expect(order.reload.fulfilled?).to be(true)
  end

  it 'unfulfills an order' do
    order2 = create(:order, fulfilled_on: Date.today)
    order2.unfulfill

    expect(order2.reload.fulfilled?).to be(false)
  end
end
