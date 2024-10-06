class CatalogueVariant < ApplicationRecord
	belongs_to :catalogue
	belongs_to :catalogue_variant_color
	belongs_to :catalogue_variant_size

	has_many :wishlists

	has_many :offers

	has_many :order_items


	

  has_many :attachments, class_name: 'CatalogueAttachment', foreign_key: 'catalogue_variant_id', dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def discounted_price
	active_offer = offers.where('start_date <= ? AND end_date >= ?', Date.today,Date.today).first
	if active_offer
		discount_amount = (price.to_f*active_offer.discount / 100)
		price.to_f - discount_amount 
		else
			price.to_f
	end
  end
end
