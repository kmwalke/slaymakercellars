module Admin
  class FulfillmentController < ApplicationController
    include OrderFulfillment

    before_action :logged_in?

    def index
      @fulfillment = order_fulfillment
    end
  end
end
