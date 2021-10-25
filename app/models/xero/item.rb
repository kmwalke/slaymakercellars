module Xero
  class Item < Xero::BaseRecord
    ENDPOINT = 'Item'.freeze

    def initialize(response)
      super(response)
      @id = @response['Items'][0]['ItemID']
    end

    def self.create(user, item)
      item.xero_sync_errors.each(&:destroy)
      save_xero_errors(item, Xero::Item.new(xero_api_post(user, ENDPOINT, body_params(item))))
    end

    def self.body_params(item)
      {
        code: item.xero_code,
        name: item.name,
        description: "#{item.name} - #{item.category}",
        purchaseDescription: "#{item.name} - #{item.category}",
        salesDetails: {
          unitPrice: item.price_point
        }
      }
    end
  end
end
