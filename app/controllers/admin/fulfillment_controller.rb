module Admin
  class FulfillmentController < ApplicationController
    before_action :logged_in_as_admin?

    def index
      @fulfillment = FulfillmentPlan.new
    end
  end
end
