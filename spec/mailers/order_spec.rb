require 'rails_helper'

RSpec.describe OrderMailer do
  let(:user) { create(:admin) }
  let(:order) { create(:order, assigned_to: user) }

  it 'sends assigned order email' do
    expect do
      described_class.with(assigned_to: user, order:).assigned.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
