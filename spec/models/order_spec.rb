require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:order) { FactoryBot.create(:order) }

  it 'should require a contact' do
    expect { FactoryBot.create(:order, contact_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a delivery date' do
    expect { FactoryBot.create(:order, delivery_date: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should default to undelivered' do
    expect(order.delivered).to eq(false)
  end
end
