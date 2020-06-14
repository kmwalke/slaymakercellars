module Admin
  class HomeController < ApplicationController
    before_action :logged_in?

    def index; end
  end
end
