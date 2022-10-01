require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  let(:user) { FactoryBot.create(:admin) }
  let(:order) { FactoryBot.create(:order, assigned_to: user) }

  it 'sends assigned order email' do
    expect do
      OrderMailer.with(assigned_to: user, order:).assigned.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
