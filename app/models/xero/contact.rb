module Xero
  class Contact < Xero::BaseRecord
    ENDPOINT = 'Contacts'.freeze

    def self.create(user, contact)
      return NullContact.new if Rails.env == 'test'

      Xero::Contact.new(
        xero_api_post(
          user,
          ENDPOINT,
          {
            name: contact.name,
            contactId: contact.xero_id
          }
        )
      )
    end

    def initialize(response)
      super
      @id = JSON.parse(response.body)['Contacts'][0]['ContactID']
    end

    attr_reader :id
  end
end
