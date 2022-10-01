class OrderMailer < ApplicationMailer
  def assigned
    @order = params[:order]
    mail(to: @order.assigned_to.email, subject: 'An order was assigned to you')
  end
end
