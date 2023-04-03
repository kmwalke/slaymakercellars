module Admin
  class ReportsController < ApplicationController
    before_action :must_be_admin

    def index; end

    def kegs
      @contacts = Contact.where.not(num_kegs: 0)
    end

    def orders
      @orders = Order.all
    end
  end
end
