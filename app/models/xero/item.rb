module Xero
  class Item < Xero::BaseRecord
    ENDPOINT = 'Item'.freeze

    def self.create(user, item)
      item.xero_sync_errors.each(&:destroy)
      save_xero_errors(item, Xero::Item.new(xero_api_post(user, ENDPOINT, body_params(item))))
    end

    def self.body_params(item)
      {
      }
    end
  end
end
