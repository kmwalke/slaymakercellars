class ProductsController < ApplicationController
  def index
    @category = params[:category] || Product::CATEGORIES.first
    @products = Product.where(category: @category, is_public: true).order(:name)
  end
end
