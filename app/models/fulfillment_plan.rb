class FulfillmentPlan
  attr_reader :days

  def initialize
    @plan     = { total: {} }
    @days     = Date.current...Date.current + 7
    @products = Product.in_production.order(:name)
    fill_plan

    super
  end

  def product_names
    @products.pluck(:name)
  end

  def total_amount(product)
    @plan[:total][product]
  end

  def amount(product, date)
    @plan[date][product]
  end

  private

  def fill_plan
    fill_totals
    fill_days
  end

  def fill_totals
    @products.each do |product|
      @plan[:total][product.name.to_s] = quantity(product)
    end
  end

  def fill_days
    days.each do |day|
      @plan[day] = {}

      @products.each do |product|
        @plan[day][product.name.to_s] = quantity(product, day)
      end
    end
  end

  def quantity(product, day = nil)
    line_items(product, day).map(&:quantity).sum
  end

  def line_items(product, day)
    LineItem.joins(:order).where(
      product: product,
      orders: orders_query(day)
    )
  end

  def orders_query(day)
    hash                 = { fulfilled_on: nil, deleted_at: nil }
    hash[:delivery_date] = day.beginning_of_day..day.end_of_day if day

    hash
  end
end
