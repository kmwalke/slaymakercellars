module Xero
  class Invoice < Xero::BaseRecord
    ENDPOINT = 'Invoice'.freeze

    def initialize(response)
      super(response, ENDPOINT)
    end

    def self.create(user, order)
      order.xero_sync_errors.each(&:destroy)
      save_xero_errors(order, Xero::Invoice.new(xero_api_post(user, ENDPOINT, body_params(order))))
    end

    def self.body_params(order)
      {
        type: 'ACCREC',
        contact: { contactId: order.contact.xero_id },
        date: delivery_date(order),
        dueDate: delivery_date(order) + 30,
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

    def self.public_url(order)
      parse_url_response(xero_api_get(User.find_sole_by(email: 'kent@slaymakercellars.com'),
                                      public_url_endpoint(order)))
    end

    def self.public_url_endpoint(order)
      "Invoices/#{order.xero_id}/OnlineInvoice"
    end

    def self.parse_url_response(response)
      JSON.parse(response.body)['OnlineInvoices'][0]['OnlineInvoiceUrl']
    end

    private_class_method def self.delivery_date(order)
      return Time.zone.today if order.delivery_date < Time.zone.today

      order.delivery_date
    end
  end
end
