module Customer
  class OrdersController < ApplicationController
    before_action :must_be_customer

    def show
      @order = Order.find(params[:id])
    end
  end
end
