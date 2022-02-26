FactoryBot.define do
  factory :order do
    contact
    delivery_date { Date.current }
    created_by factory: :admin
  end
end
