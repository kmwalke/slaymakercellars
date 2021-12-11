module OrderFulfillment
  extend ActiveSupport::Concern

  def order_fulfillment
    result = {}
    week = Date.today...Date.today + 7

    week.each do |day|
      result[day] = {}

      Product.all.each do |product|
        result[day][product.name] = 0

        Order.to_be_fulfilled(day).each do |order|
          order.line_items.where(product_id: product.id).map { |line_item| result[day][product.name] += line_item.quantity }
        end
      end
    end

    result
  end
end
