class OrderMailer < ApplicationMailer
  def assigned
    @assigned_to = params[:assigned_to]
    @order       = params[:order]
    mail(to: @assigned_to.email, subject: 'An order was assigned to you')
  end
end
