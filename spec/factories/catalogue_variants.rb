FactoryBot.define do
  factory :catalogue_variant do
    catalogue
    catalogue_variant_color { association :catalogue_variant_color }
    catalogue_variant_size { association :catalogue_variant_size }
    price { 100.0 }
    quantity { 10 }
  end
end