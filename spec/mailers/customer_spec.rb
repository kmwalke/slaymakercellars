require 'rails_helper'

RSpec.describe CustomerMailer, type: :mailer do
  let(:customer) { FactoryBot.create(:customer) }

  it 'sends welcome email' do
    expect do
      CustomerMailer.with(user: customer).welcome.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends new user email' do
    FactoryBot.create(:admin)
    expect do
      CustomerMailer.with(user: customer).new_customer.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends account activated email' do
    expect do
      CustomerMailer.with(user: customer).account_activated.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
