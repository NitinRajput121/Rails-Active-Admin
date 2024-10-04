class CartSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :token, :created_at, :total_amount, :cart_items

  def total_amount
    object.cart_items.sum do |item|
      # Check if the catalogue_variant has a discounted price
      if item.catalogue_variant.discounted_price < item.catalogue_variant.price
        item.catalogue_variant.discounted_price * item.quantity
      else
        item.catalogue_variant.price * item.quantity
      end
    end
  end

   has_many :cart_items


  

end
