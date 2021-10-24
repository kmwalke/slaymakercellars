class Xero::Contact < Xero::BaseRecord
  def self.create(user, contact)
    id(xero_api_post_contact(user, contact))
  end

  def self.id(response)
    JSON.parse(response.body)['Contacts'][0]['ContactID']
  end
end