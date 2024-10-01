class Offer < ApplicationRecord
	 belongs_to :catalogue_variant

    validates :offer_name, presence:true
    validates :discount, presence:true, numericality: {greater_than: 0, less_than_or_equal_to: 100}
    validates :start_date, presence:true
    validates :end_date, presence:true


def discounted_price
    if catalogue_variant.present?
      discount_amount = (catalogue_variant.price.to_f * discount / 100)
      catalogue_variant.price.to_f - discount_amount
    else
      0 # Return 0 or nil if no feature is associated
    end
end

end
