class CustomerMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Account Created for Slaymaker Cellars')
  end

  def account_activated
    @user = params[:user]
    mail(to: @user.email, subject: 'Account Activated for Slaymaker Cellars')
  end
end
