module Admin
  class StatesController < ApplicationController
    before_action :set_state, only: [:edit, :update, :destroy]
    before_action :must_be_admin

    def index
      @states = State.order(:name)
    end

    def new
      @state = State.new
    end

    def edit; end

    def create
      @state = State.new(state_params)

      respond_to do |format|
        if @state.save
          format.html { redirect_to admin_states_path, notice: 'State was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @state.update(state_params)
          format.html { redirect_to admin_states_path, notice: 'State was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @state.destroy
      respond_to do |format|
        format.html { redirect_to admin_states_path, notice: 'State was successfully destroyed.' }
      end
    end

    private

    def set_state
      @state = State.find(params[:id])
    end

    def state_params
      params.require(:state).permit(:name, :abbreviation)
    end
  end
end
