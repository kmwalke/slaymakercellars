class OrderMailer < ApplicationMailer
  def assigned
    @user  = params[:user]
    @order = params[:order]
    mail(to: @user.email, subject: 'An order was assigned to you')
  end
end
