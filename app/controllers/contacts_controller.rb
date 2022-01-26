class ContactsController < ApplicationController
  def index
    @states = State.all.includes(:towns)
  end
end
