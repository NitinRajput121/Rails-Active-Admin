FactoryBot.define do
  factory :order do
    total_price { 100.00 }
    status { 'paid' }
    association :user
  end
end