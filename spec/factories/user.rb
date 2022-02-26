FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User_#{n}" }
    email { "#{name}@email.com" }
    password { '123' }
  end

  factory :admin, parent: :user do
    role { User::ROLES[:admin] }
  end

  factory :customer, parent: :user do
    contact
    role { User::ROLES[:customer] }
  end
end
