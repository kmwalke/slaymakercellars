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

  it 'should not allow admins to have a contact' do
    user    = FactoryBot.create(:admin)
    contact = FactoryBot.create(:contact)

    user.update(contact_id: contact.id)

    expect(user.reload.contact_id).to be_nil
  end

  it 'should scope email admins' do
    no_email_admin = FactoryBot.create(:admin, receives_emails: false)
    email_admin = FactoryBot.create(:admin, receives_emails: true)
    customer = FactoryBot.create(:customer)

    admins = User.emailable_admins

    expect(admins).to include(email_admin)
    expect(admins).not_to include(no_email_admin)
    expect(admins).not_to include(customer)
  end
end
