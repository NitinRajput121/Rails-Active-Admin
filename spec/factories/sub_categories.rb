FactoryBot.define do
  factory :sub_category do
    name { "Mobile Phones" }
    association :category
  end
end