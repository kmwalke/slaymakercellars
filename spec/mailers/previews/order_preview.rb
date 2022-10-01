# Preview all emails at http://localhost:3000/rails/mailers
class OrderPreview < ActionMailer::Preview
  def assigned
    user  = FactoryBot.build(:admin)
    order = FactoryBot.build(:order, user: user)
    OrderMailer.with(user: user, order: order).assigned
  end
end
