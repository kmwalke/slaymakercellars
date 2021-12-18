FactoryBot.define do
  factory :order do
    contact
    delivery_date { Date.today }
    created_by factory: :user
  end
end
