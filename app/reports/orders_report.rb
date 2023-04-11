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
      1
    end

    def calc_value
      15
    end
  end
end
