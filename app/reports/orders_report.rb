class OrdersReport
  attr :start_date, :end_date, :orders

  def initialize(start_date, end_date)
    return if start_date.blank? || end_date.blank?

    @start_date = DateTime.parse("#{start_date} 00:00:00")
    @end_date   = DateTime.parse("#{end_date} 23:59:59")
    @orders     = Order.where(created_at: @start_date..@end_date)
  end

  def dates
    [@start_date, @end_date]
  end
end