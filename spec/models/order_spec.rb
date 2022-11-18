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
end
