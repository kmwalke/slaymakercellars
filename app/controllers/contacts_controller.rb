class ContactsController < ApplicationController
  def index
    @states = State.with_active_towns
  end
end
