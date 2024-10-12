

class CatalogueVariantSerializer

    include JSONAPI::Serializer

  attributes :id, :price, :catalogue_variant_color_id, :catalogue_variant_size_id




    # attribute :color do |object|
    #    object.catalogue_variant_color.name
    # end 


    # attribute :size do |object|
    #    object.catalogue_variant_size.name
    # end 

  # attribute :offer_name do |object|
  #   active_offer = object.offers.where('start_date <= ? AND end_date >= ?', Date.today, Date.today).first
  #   active_offer ? active_offer.offer_name : nil
  # end

  # def discounted_price
  #   object.discounted_price
  # end
end
