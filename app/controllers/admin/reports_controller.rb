module Admin
  class ReportsController < ApplicationController
    before_action :must_be_admin

    def index; end

    def kegs
      @contacts = Contact.where.not(num_kegs: 0)
    end

    def orders
      @start_date, @end_date = dates(params[:start_date], params[:end_date])
      @orders                = wholesale_orders(@start_date, @end_date)
    end

    private

    def dates(start_date, end_date)
      return [nil, nil] if start_date.blank? || end_date.blank?

      [start_date.to_date, end_date.to_date]
    end

    def wholesale_orders(start_date, end_date)
      return if start_date.blank? || end_date.blank?

      Order.where(created_at: start_date..end_date)
    end
  end
end
