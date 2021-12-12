module Admin
  class FulfillmentController < ApplicationController
    before_action :logged_in?

    def index
      @fulfillment = FulfillmentPlan.new
    end
  end
end
