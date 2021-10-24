class Xero::Contact < Xero::BaseRecord
  def self.create(user, contact)
    Xero::Contact.new(xero_api_post_contact(user, contact))
  end

  def initialize(response)
    @id = JSON.parse(response.body)['Contacts'][0]['ContactID']
  end

  def id
    @id
  end
end