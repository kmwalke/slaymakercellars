class OrdersReport
  attr_reader :start_date, :end_date, :orders

  def initialize(start_date, end_date)
    return if start_date.blank? || end_date.blank?

    @start_date = DateTime.parse("#{start_date} 00:00:00")
    @end_date   = DateTime.parse("#{end_date} 23:59:59")
    @orders     = wholesale_orders
  end

  def dates
    [@start_date, @end_date]
  end

  def num_items
    @orders.map(&:num_items).sum
  end

  def value
    @orders.map(&:value).sum
  end

  private

  def wholesale_orders
    Order.where(created_at: @start_date..@end_date).map do |order|
      MockOrder.new(order)
    end
  end

  class MockOrder
    attr_reader :id, :num_items, :order, :value

    def initialize(order)
      @id        = order.id
      @order     = order
      @num_items = count_items
      @value     = calc_value
    end

    def count_items
      @order.line_items.map(&:quantity).sum
    end

    def calc_value
      @order.line_items.map { |li| li.quantity * li.price_point }.sum.round(2)
    end
  end
end
