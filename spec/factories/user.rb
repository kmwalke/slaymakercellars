FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User_#{n}" }
    email { "#{name}@email.com" }
    password { '123' }
  end
end
