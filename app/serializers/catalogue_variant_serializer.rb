# class CatalogueVariantSerializer < ActiveModel::Serializer
#   attributes :id, :price

 




 



#     attribute :color do |object|
#        object.object.catalogue_variant_color.name
#     end 


#     attribute :size do |object|
#        object.object.catalogue_variant_size.name
#     end 

# end

 # has_many :offers, if: -> { object.offers.any? }
 
   # belongs_to :catalogue_variant_size, serializer: CatalogueVariantSizeSerializer, if: -> { object.catalogue_variant_size.present? }

  # belongs_to :catalogue_variant_color, serializer: CatalogueVariantColorSerializer, if: -> { object.catalogue_variant_color.present? } 


class CatalogueVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :discounted_price, :offer_name




    attribute :color do |object|
       object.object.catalogue_variant_color.name
    end 


    attribute :size do |object|
       object.object.catalogue_variant_size.name
    end 

    def offer_name
      active_offer = object.offers.where('start_date <= ? AND end_date >= ?', Date.today, Date.today).first
      active_offer ? active_offer.offer_name : nil
    end

  def discounted_price
    object.discounted_price
  end
end
