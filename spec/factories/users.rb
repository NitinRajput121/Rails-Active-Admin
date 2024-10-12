FactoryBot.define do
  factory :user do
    name { "Abhishek" }
    sequence(:email) { |n| "jo#{n}@example.com" }
    password { "password@123" }
    user_type { "customer" }
    stripe_customer_id { nil } 
    
  end
end







