require 'rails_helper'

RSpec.describe CustomerMailer, type: :mailer do
  let(:customer) { FactoryBot.create(:customer) }

  it 'sends welcome email' do
    expect(
      CustomerMailer.with(user: customer).welcome
    ).to be_kind_of(ActionMailer::Parameterized::MessageDelivery)
  end

  it 'sends new user email' do
    expect(
      CustomerMailer.with(user: customer).account_activated
    ).to be_kind_of(ActionMailer::Parameterized::MessageDelivery)
  end

  it 'sends account activated email' do
    expect(
      CustomerMailer.with(user: customer).new_customer
    ).to be_kind_of(ActionMailer::Parameterized::MessageDelivery)
  end
end
