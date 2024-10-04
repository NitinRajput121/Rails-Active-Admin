  class CartItemSerializer < ActiveModel::Serializer
    attributes :id, :quantity, :catalogue_variant

    def catalogue_variant
      {
        name: object.catalogue_variant.catalogue.name,
        price: object.catalogue_variant.price,
        color: object.catalogue_variant.catalogue_variant_color.name,  # Assuming `name` is an attribute of color
        size: object.catalogue_variant.catalogue_variant_size.name,  
        offer_name: active_offer_name,
        discounted_price: object.catalogue_variant.discounted_price

      }
    end



      private

  def active_offer_name
    active_offer = object.catalogue_variant.offers.where('start_date <= ? AND end_date >= ?', Date.today, Date.today).first
    active_offer ? active_offer.offer_name : nil
  end

  end

