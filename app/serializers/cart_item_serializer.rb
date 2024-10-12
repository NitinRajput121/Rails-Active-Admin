
class CartItemSerializer
  include JSONAPI::Serializer

  attributes :id, :quantity

  attribute :catalogue_variant do |cart_item|
    {
      name: cart_item.catalogue_variant.catalogue.name,
      price: cart_item.catalogue_variant.price,
      color: cart_item.catalogue_variant.catalogue_variant_color.name, # Assuming `name` is an attribute of color
      size: cart_item.catalogue_variant.catalogue_variant_size.name,
      offer_name: active_offer_name(cart_item),
      discounted_price: cart_item.catalogue_variant.discounted_price
    }
  end

  private

  def self.active_offer_name(cart_item)
    active_offer = cart_item.catalogue_variant.offers
                     .where('start_date <= ? AND end_date >= ?', Date.today, Date.today)
                     .first
    active_offer ? active_offer.offer_name : nil
  end
end

