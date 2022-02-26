module Customer
  class HomeController < ApplicationController
    before_action :logged_in_as_customer?

    def index
    end
  end
end
