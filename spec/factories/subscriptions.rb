FactoryBot.define do
  factory :subscription do
    association :user 
    plan_id { 1 } 
    started_at { 1.day.ago }
    expires_at { 1.month.from_now }
  end
end

