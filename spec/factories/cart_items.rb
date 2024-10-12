FactoryBot.define do
  factory :cart_item do
    association :cart
    association :catalogue_variant
    quantity { Faker::Number.between(from: 1, to: 10) } # Random quantity between 1 and 10
  end
end
