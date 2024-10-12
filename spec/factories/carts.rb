FactoryBot.define do
  factory :cart do
    user { association :user } # or set to nil for guest carts
    token { SecureRandom.hex(10) } # Generates a unique token

    trait :guest_cart do
      user { nil }
    end
  end
end