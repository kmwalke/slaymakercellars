require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:order) { Order.create(contact: contact, delivery_date: 1.week.from_now) }

  it 'should require a contact' do
    expect(Order.create(contact_id: nil).errors).to have_key(:contact)
  end

  it 'should require a delivery date' do
    expect(Order.create(delivery_date: '').errors).to have_key(:delivery_date)
  end

  it 'should default to undelivered' do
    expect(order.delivered).to eq(false)
  end
end
