module Customer
  class HomeController < ApplicationController
    before_action :must_be_customer

    def index
      @orders = current_user.contact.orders.where(deleted_at: nil) if current_user.customer_activated?
    end
  end
end
