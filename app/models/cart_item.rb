class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :catalogue_variant

  validates :quantity, numericality: { greater_than: 0 }
end
