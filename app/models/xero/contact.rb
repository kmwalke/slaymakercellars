module Xero
  class Contact < Xero::BaseRecord
    ENDPOINT = 'Contacts'.freeze

    def self.create(user, contact)
      return NullContact.new if Rails.env == 'test'

      Xero::Contact.new(
        xero_api_post(
          user,
          ENDPOINT,
          post_body(contact)
        )
      )
    end

    def initialize(response)
      super
      @id = JSON.parse(response.body)['Contacts'][0]['ContactID']
    end

    attr_reader :id
  end

  private

  def post_body(contact)
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
      addresses: post_body_addresses(contact)
    }
  end

  def post_body_addresses(contact)
    [
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
  end
end
