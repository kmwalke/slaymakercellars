class ContactsController < ApplicationController
  def index
    @states = State.all
  end
end
