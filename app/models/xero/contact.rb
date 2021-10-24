module Xero
  class Contact < Xero::BaseRecord
    ENDPOINT = 'Contacts'.freeze

    def self.create(user, contact)
      return NullContact.new if Rails.env == 'test'

      contact.xero_sync_errors.each do |error|
        error.destroy
      end

      xero_contact = Xero::Contact.new(
        xero_api_post(
          user,
          ENDPOINT,
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
        )
      )

      xero_contact.errors&.each do |error|
        puts error
        contact.xero_sync_errors << XeroSyncError.new(message: error['Message'])
      end

      xero_contact
    end

    def initialize(response)
      super
      body = JSON.parse(response.body)
      if response.status == 400
        @errors = body['Elements'][0]['ValidationErrors']
        return
      end

      @id = body['Contacts'][0]['ContactID']
    end

    attr_reader :id, :errors
  end
end
