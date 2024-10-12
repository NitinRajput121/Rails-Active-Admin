class OfferSerializer 

 include JSONAPI::Serializer

  attributes :id, :offer_name, :discount, :start_date, :end_date, :discounted_price
   


  attribute :original_price do |object|
    object.catalogue_variant.price
  end

  attribute :quantity do |object|
    object.catalogue_variant.quantity
  end

  def discounted_price
    object.discounted_price
  end

  attribute :catalogue_name do |object|
    object.catalogue_variant.catalogue.name
  end



end

  # belongs_to :catalogue_variant, serializer: CatalogueVariantSerializer, if: -> { object.catalogue_variant.present? }


  # attribute :catalogue_variant_name do |object|
  #   object.object.catalogue_variant.name
  # end
