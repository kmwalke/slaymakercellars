module Admin
  class FulfillmentController < ApplicationController
    before_action :logged_in?

    def index
      @fulfillment = FulfillmentPlan.new
    end
  end
end

class FulfillmentPlan
  attr_reader :days

  def initialize
    @plan     = {}
    @days     = Date.today...Date.today + 7
    @products = Product.all
    fill_plan

    super
  end

  def product_names
    @products.pluck(:name)
  end

  def amount(date, product)
    @plan[date][product]
  end

  private

  def fill_plan
    days.each do |day|
      @plan[day] = {}

      @products.each do |product|
        @plan[day][product.name.to_s] = 0

        Order.to_be_fulfilled(day).each do |order|
          order.line_items.where(product_id: product.id).map do |line_item|
            @plan[day][product.name.to_s] += line_item.quantity
          end
        end
      end
    end
  end
end
