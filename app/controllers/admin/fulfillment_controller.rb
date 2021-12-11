module Admin
  class FulfillmentController < ApplicationController
    before_action :logged_in?

    def index
      @fulfillment = order_fulfillment
    end

    private

    def order_fulfillment
      result = {}
      week   = Date.today...Date.today + 7

      week.each do |day|
        result[day] = {}

        Product.all.each do |product|
          result[day][product.name] = {}
          total                     = 0

          Order.to_be_fulfilled(day).each do |order|
            li                  = order.line_items.where(product_id: product.id)
            li.map { |l| total += l.quantity }
          end
          result[day][product.name] = total
        end
      end

      result
    end
  end
end
