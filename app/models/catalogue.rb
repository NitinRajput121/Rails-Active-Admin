class Catalogue < ApplicationRecord
	has_many :catalogue_variants, dependent: :destroy
	has_many :cart_items
    has_many :wishlists
	belongs_to :category
	belongs_to :sub_category

    enum gender: { male: 0, female: 1, unisex: 2 }


	accepts_nested_attributes_for :catalogue_variants, allow_destroy: true

    scope :filter_by_gender, -> (gender) { where(gender: gender)}
	scope :search, ->(q) { where("name LIKE ? OR description LIKE ?", "%#{q}%", "%#{q}%") }
    scope :sorted_by, ->(sorted_by) { order(sorted_by) }

  
	validates :name, presence: true
	validates :category, presence: true
	validates :sub_category, presence: true
end
