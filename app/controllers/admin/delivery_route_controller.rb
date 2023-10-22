module Admin
  class DeliveryRouteController < ApplicationController
    before_action :must_be_admin

    def index
      @orders = Order.active.includes(contact: :town).includes(:assigned_to)
    end

    def show
      @url = delivery_route_url(delivery_route_params)
    end

    private

    def delivery_route_url(orders)
      Google::Directions.query_url(addresses(orders))
    end

    def addresses(orders)
      addresses = []
      Order.where(id: order_ids(orders)).find_each do |o|
        addresses << o.contact.full_address
      end
      addresses
    end

    def order_ids(orders)
      order_ids = []
      orders.each do |k, v|
        order_ids << k.to_i if v == '1'
      end
      order_ids
    end

    def delivery_route_params
      params.require('order').permit!
    end
  end
end
