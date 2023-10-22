module Admin
  class SalesRepsController < ApplicationController
    before_action :set_sales_rep, only: [:edit, :update, :destroy]
    before_action :must_be_admin

    def index
      @sales_reps = SalesRep.order('sales_reps.name')
    end

    def show; end

    def new
      @sales_rep = SalesRep.new
    end

    def edit; end

    def create
      @sales_rep = SalesRep.new(sales_rep_params)

      respond_to do |format|
        if @sales_rep.save
          format.html { redirect_to admin_sales_reps_path, notice: 'SalesRep was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @sales_rep.update(sales_rep_params)
          format.html { redirect_to admin_sales_reps_path, notice: 'SalesRep was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @sales_rep.destroy
      respond_to do |format|
        format.html { redirect_to admin_sales_reps_path, notice: 'SalesRep was successfully destroyed.' }
      end
    end

    private

    def set_sales_rep
      @sales_rep = SalesRep.find(params[:id])
    end

    def sales_rep_params
      params.require(:sales_rep).permit(:email, :name)
    end
  end
end
