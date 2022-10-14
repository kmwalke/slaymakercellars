module Admin
  class DeliveryRouteController < ApplicationController
    before_action :must_be_admin

    def index
      @orders = Order.active
    end
  end
end
