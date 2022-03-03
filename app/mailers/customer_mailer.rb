class CustomerMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Account Created for Slaymaker Cellars')
  end

  def account_activated
    @user = params[:user]
    mail(to: @user.email, subject: 'Account Activated for Slaymaker Cellars')
  end

  def new_customer
    @user = params[:user]
    mail(to: User.emailable_admins.pluck(:email), subject: 'New Wholesale Customer Account')
  end
end
