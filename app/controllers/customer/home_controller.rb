module Customer
  class HomeController < ApplicationController
    before_action :must_be_customer

    def index; end
  end
end
