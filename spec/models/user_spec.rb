require 'rails_helper'

RSpec.describe User do
  it 'requires a name' do
    expect(described_class.create(name: '').errors).to have_key(:name)
  end

  it 'requires an email' do
    expect(described_class.create(email: '').errors).to have_key(:email)
  end

  it 'requires email uniqueness' do
    user = create(:admin)
    expect { create(:admin, email: user.email) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'does not allow admins to have a contact' do
    user    = create(:admin)
    contact = create(:contact)

    user.update(contact_id: contact.id)

    expect(user.reload.contact_id).to be_nil
  end

  it 'does not list private admins in emailable admins' do
    no_email_admin = create(:admin, receives_emails: false)

    expect(described_class.emailable_admins).not_to include(no_email_admin)
  end

  it 'lists admins in emailable admins' do
    email_admin = create(:admin, receives_emails: true)

    expect(described_class.emailable_admins).to include(email_admin)
  end

  it 'does not list customers in emailable admins' do
    customer = create(:customer)

    expect(described_class.emailable_admins).not_to include(customer)
  end
end
