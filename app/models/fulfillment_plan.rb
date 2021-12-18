class FulfillmentPlan
  attr_reader :days

  def initialize
    @plan     = { total: {} }
    @days     = Date.current...Date.current + 7
    @products = Product.in_production.order(:name)
    @orders   = active_orders
    fill_plan
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
    fill_products(:total)
  end

  def fill_days
    days.each do |day|
      @plan[day] = {}

      fill_products(day, day)
    end
  end

  def fill_products(key, day = nil)
    @products.each do |product|
      @plan[key][product.name.to_s] = quantity(product, day)
    end
  end

  def quantity(product, day = nil)
    convert_to_cases(
      line_items(product, day).map(&:quantity).sum,
      product.case_size
    )
  end

  def convert_to_cases(quantity, case_size)
    {
      cases: (quantity / case_size).floor,
      bottles: quantity % case_size
    }
  end

  def line_items(product, day = nil)
    orders(day).map(&:line_items).flatten.select { |li| li.product_id == product.id }
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
