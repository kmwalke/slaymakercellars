# Preview all emails at http://localhost:3000/rails/mailers/customer
class CustomerPreview < ActionMailer::Preview
  def welcome
    CustomerMailer.with(user: FactoryBot.build(:customer)).welcome
  end

  def account_activated
    CustomerMailer.with(user: FactoryBot.build(:customer)).account_activated
  end

  def new_customer
    CustomerMailer.with(user: FactoryBot.build(:customer)).new_customer
  end
end
