module Admin
  class TownsController < ApplicationController
    before_action :set_town, only: [:show, :edit, :update, :destroy]

    def index
      @towns = Town.all
    end

    def show
    end

    def new
      @town = Town.new
    end

    def edit
    end

    def create
      @town = Town.new(town_params)

      respond_to do |format|
        if @town.save
          format.html { redirect_to admin_towns_path, notice: 'Town was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @town.update(town_params)
          format.html { redirect_to admin_towns_path, notice: 'Town was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @town.destroy
      respond_to do |format|
        format.html { redirect_to admin_towns_path, notice: 'Town was successfully destroyed.' }
      end
    end

    private

    def set_town
      @town = Town.find(params[:id])
    end

    def town_params
      params.require(:town).permit(:name, :state_id)
    end
  end
end
