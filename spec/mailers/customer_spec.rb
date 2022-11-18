require 'rails_helper'

RSpec.describe CustomerMailer do
  let(:customer) { create(:customer) }

  it 'sends welcome email' do
    expect do
      described_class.with(user: customer).welcome.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends new user email' do
    create(:admin)
    expect do
      described_class.with(user: customer).new_customer.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends account activated email' do
    expect do
      described_class.with(user: customer).account_activated.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
