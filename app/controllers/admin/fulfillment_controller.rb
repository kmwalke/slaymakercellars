module Admin
  class FulfillmentController < ApplicationController
    before_action :must_be_admin

    def index
      @fulfillment = FulfillmentPlan.new
    end
  end
end
