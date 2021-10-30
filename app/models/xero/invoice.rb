module Xero
  class Invoice < Xero::BaseRecord
    ENDPOINT = 'Invoices'.freeze

    def initialize(response)
      super(response)
      @id = @response['Invoices'][0]['InvoiceID']
    end

    def self.create(user, order)
      order.xero_sync_errors.each(&:destroy)
      save_xero_errors(order, Xero::Invoice.new(xero_api_post(user, ENDPOINT, body_params(order))))
    end

    def self.body_params(order)
      {
        type: 'ACCREC',
        contact: { contactId: order.contact.xero_id },
        lineItems:
          order.line_items.map do |line_item|
            {
              description: 'desc',
              quantity: 1,
              unitAmount: 12.99,
              itemCode: line_item.product.xero_code
            }
          end
      }
    end
  end
end
