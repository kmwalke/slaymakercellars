module Admin
  class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy, :undestroy]
    before_action :logged_in?

    def index
      @orders, @title = Order.display_all(params[:show] || 'active')
      @show           = params[:show]
    end

    def new
      @order = Order.new
    end

    def edit
      redirect_to admin_order_path(@order) if @order.fulfilled?
    end

    def create
      @order = Order.new(order_params.merge(created_by: current_user))

      respond_to do |format|
        if @order.save
          format.html { redirect_to admin_orders_path, notice: 'Order was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      path = params[:save] ? admin_orders_url : edit_admin_order_url(@order)
      respond_to do |format|
        if @order.update(order_params.merge(updated_by: current_user))
          format.html { redirect_to path, notice: 'Order was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def fulfill
      @order = Order.find(params[:id])
      @order.fulfill

      respond_to do |format|
        if @order.save
          format.html do
            redirect_to admin_orders_path,
                        notice: 'Order was successfully delivered. <br /><br />' \
                                "<a href=\"/admin/orders/#{@order.id}\">View Order</a>"
          end
        else
          format.html { redirect_to admin_orders_path, notice: 'Error' }
        end
      end
    end

    def unfulfill
      @order = Order.find(params[:id])
      @order.unfulfill

      respond_to do |format|
        if @order.save
          format.html { redirect_to edit_admin_order_path(@order), notice: 'Order was successfully undelivered.' }
        else
          format.html { redirect_to admin_order_path(@order), notice: 'Error' }
        end
      end
    end

    def destroy
      notice = @order.destroy
      respond_to do |format|
        format.html { redirect_to admin_orders_path, notice: "Order was successfully #{notice}." }
      end
    end

    def undestroy
      @order.undestroy
      respond_to do |format|
        format.html { redirect_to admin_orders_path, notice: 'Order was made active.' }
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(
        :contact_id,
        :delivery_date,
        :customer_po,
        :comments,
        :created_by_id,
        :updated_by_id,
        line_items_attributes: [:fulfilled, :quantity, :product_id, :id, :_destroy]
      )
    end
  end
end
