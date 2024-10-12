FactoryBot.define do
  factory :subscription do
    association :plan
    user
    started_at { 1.day.ago }
    expires_at { 1.month.from_now }
  end
end

