# Preview all emails at http://localhost:3000/rails/mailers
class OrderPreview < ActionMailer::Preview
  def assigned
    user  = FactoryBot.build(:admin)
    order = FactoryBot.build(:order, user:)
    OrderMailer.with(user:, order:).assigned
  end
end
