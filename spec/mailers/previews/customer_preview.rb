# Preview all emails at http://localhost:3000/rails/mailers/customer
class CustomerPreview < ActionMailer::Preview
  def welcome
    CustomerMailer.with(user: FactoryBot.build(:customer)).welcome
  end
end
