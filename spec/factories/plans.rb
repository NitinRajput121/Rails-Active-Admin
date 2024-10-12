FactoryBot.define do
  factory :plan do
    name { "Premium Plan" }
    plan_type { "paid" }
    price_monthly { 100.0 }
    price_yearly { 1000.0 }
    discount { true }
    discount_type { "Percentage" }
    discount_percentage { 20 }
  end
end

