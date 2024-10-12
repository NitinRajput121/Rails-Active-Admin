FactoryBot.define do
  factory :user do
    name { "Abhishek" }
    sequence(:email) { |n| "jo#{n}@example.com" }
    password { "password@123" }
    user_type { "customer" }
    stripe_customer_id { nil } 
   

    after(:create) do |user|
      create(:subscription, user: user, started_at: Time.current, expires_at: 1.month.from_now)
    end

  end
end







