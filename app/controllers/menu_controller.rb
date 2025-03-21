class MenuController < ApplicationController
  def index
    @menu_sections = MenuSection.all.order(:position)
  end
end
