FactoryBot.define do
  factory :note do
    body { 'This is a note.' }
    contact
    created_by factory: :admin
  end
end
