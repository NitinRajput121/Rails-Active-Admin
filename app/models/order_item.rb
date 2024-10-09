class OrderItem < ApplicationRecord
	belongs_to :order
	belongs_to :catalogue_variant
end
