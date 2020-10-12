module Admin
  class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :destroy]
    before_action :logged_in?

    def index
      @products = Product.all
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
      params.require(:product).permit(:name, :bottle_image)
    end
  end
end
