module Admin
  class HomeController < ApplicationController
    before_action :logged_in?

    def index
      @late_orders     = Order.where('delivery_date < ? and fulfilled_on is NULL', Date.today).count
      @orders          = Order.where(fulfilled_on: nil).count
      @todays_orders   = Order.where(fulfilled_on: nil, delivery_date: Date.today).count
      @contacts        = Contact.count
      @urgent_contacts = Contact.urgent.count
      @states          = State.count
      @towns           = Town.count
      @products        = Product.count
    end
  end
end
