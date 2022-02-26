require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should require a name' do
    expect(User.create(name: '').errors).to have_key(:name)
  end

  it 'should require an email' do
    expect(User.create(email: '').errors).to have_key(:email)
  end

  it 'should require email uniqueness' do
    user = FactoryBot.create(:admin)
    expect { FactoryBot.create(:admin, email: user.email) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
