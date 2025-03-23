class MenuController < ApplicationController
  def index
    @menu_sections = MenuSection.order(:position)
  end
end
