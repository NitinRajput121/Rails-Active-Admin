class Offer < ApplicationRecord
	 belongs_to :catalogue_variant

    validates :offer_name, presence:true
    validates :discount, presence:true, numericality: {greater_than: 0, less_than_or_equal_to: 100}
    validates :start_date, presence:true
    validates :end_date, presence:true
end
