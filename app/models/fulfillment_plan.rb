class FulfillmentPlan
  attr_reader :days

  def initialize
    @plan     = { total: {} }
    @days     = Date.current...Date.current + 7
    @products = Product.in_production.order(:name)
    @orders   = active_orders
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

  def to_a
    @plan
  end

  private

  def active_orders
    Order.includes(:line_items)
         .where(
           fulfilled_on: nil,
           deleted_at: nil,
           line_items: {
             product: @products
           }
         )
  end

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
    orders(day).map(&:line_items).flatten.select { |li| li.product_id == product.id }.map(&:quantity).sum
  end

  def orders(day = nil)
    if day
      if day == Date.today
        @orders.select { |o| o.delivery_date <= day }
      else
        @orders.select { |o| o.delivery_date == day }
      end
    else
      @orders
    end
  end
end
