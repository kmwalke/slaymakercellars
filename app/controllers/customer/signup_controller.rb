module Customer
  class SignupController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params.merge(role: User::ROLES[:customer]))

      respond_to do |format|
        if @user.save
          CustomerMailer.with(user: @user).welcome.deliver_later
          format.html { redirect_to customer_path }
        else
          format.html { render :new }
        end
      end
    end

    def user_params
      params.require(:user).permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end
  end
end
