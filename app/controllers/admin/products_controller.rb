module Admin
  class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :destroy]
    before_action :must_be_admin
    after_action :sync_to_xero, only: [:update, :create]

    def index
      @products = Product.order(:category, :name)
    end

    def new
      @product = Product.new
    end

    def edit; end

    def create
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html { redirect_to admin_products_path, notice: 'Product was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to admin_products_path, notice: 'Product was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @product.destroy
      respond_to do |format|
        format.html { redirect_to admin_products_path, notice: 'Product was successfully destroyed.' }
      end
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :category,
        :case_size,
        :description,
        :in_production,
        :is_public,
        :name,
        :price_point,
        :xero_code
      )
    end

    def sync_to_xero
      super(@product, Xero::Item)
    end
  end
end
