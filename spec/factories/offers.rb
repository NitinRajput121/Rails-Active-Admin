FactoryBot.define do
  factory :offer do
    offer_name { "Special Offer" }
    discount { 10.0 }  # Default 10% discount
    start_date { Time.current }
    end_date { 1.week.from_now }
    association :catalogue_variant
  end
end
