class ProductsController < ApplicationController
  def index
    @products = wine_list.wines
  end
end
