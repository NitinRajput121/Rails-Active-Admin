FactoryBot.define do
  factory :order_item do
    association :order
    association :catalogue_variant
    quantity { 1 }
    price { 50.00 }
  end
end