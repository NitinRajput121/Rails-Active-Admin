FactoryBot.define do
  factory :catalogue do
    name { "iPhone" }
    description { "Latest Apple iPhone" }
    gender { :unisex }
    association :category
    association :sub_category
  end
end