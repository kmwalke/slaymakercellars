module Xero
  class Invoice < Xero::BaseRecord
    ENDPOINT = 'Invoices'.freeze

    def initialize(response)
      super(response)
      @id = @response['Invoices'][0]['InvoiceID'] if errors.nil?
    end

    def self.create(user, order)
      order.xero_sync_errors.each(&:destroy)
      save_xero_errors(order, Xero::Invoice.new(xero_api_post(user, ENDPOINT, body_params(order))))
    end

    def self.body_params(order)
      {
        type: 'ACCREC',
        contact: { contactId: order.contact.xero_id },
        date: order.delivery_date,
        dueDate: order.delivery_date + 30,
        status: 'AUTHORISED',
        reference: order.customer_po,
        lineItems:
          order.line_items.map do |line_item|
            {
              description: "#{line_item.product.name} - #{line_item.product.category}",
              quantity: line_item.quantity,
              unitAmount: line_item.price_point,
              itemCode: line_item.product.xero_code,
              accountCode: '400'
            }
          end
      }
    end
  end
end
