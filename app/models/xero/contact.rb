module Xero
  class Contact < Xero::BaseRecord
    ENDPOINT = 'Contacts'.freeze

    def initialize(response)
      super
    end

    def self.create(user, contact)
      return NullContact.new if Rails.env == 'test'

      contact.xero_sync_errors.each(&:destroy)
      save_xero_errors(contact, Xero::Contact.new(xero_api_post(user, ENDPOINT, body_params(contact))))
    end

    def self.body_params(contact)
      {
        contactId: contact.xero_id,
        name: contact.name,
        emailAddress: contact.email,
        firstName: contact.contact_point,
        phones: [
          {
            phoneType: 'DEFAULT',
            phoneNumber: contact.phone
          }
        ],
        addresses: [
          {
            addressType: 'POBOX',
            addressLine1: contact.address,
            city: contact.town.name,
            region: contact.town.state.name
          },
          {
            addressType: 'STREET',
            addressLine1: contact.address,
            city: contact.town.name,
            region: contact.town.state.name
          }
        ]
      }
    end
  end
end
