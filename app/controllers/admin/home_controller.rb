module Admin
  class HomeController < ApplicationController
    before_action :logged_in?

    def index
      @contacts        = Contact.count
      @urgent_contacts = Contact.urgent.count
      @states          = State.count
      @towns           = Town.count
    end
  end
end
