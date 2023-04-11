module Admin
  class ReportsController < ApplicationController
    before_action :must_be_admin

    def index; end

    def kegs
      @contacts = Contact.where.not(num_kegs: 0)
    end

    def orders
      report      = OrdersReport.new(params[:start_date], params[:end_date])
      @start_date = report.start_date
      @end_date   = report.end_date
      @orders     = report.orders
    end
  end
end
