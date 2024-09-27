class SubCategory < ApplicationRecord
	belongs_to :category
	has_many :catalogues
	validates :name, presence: true
    validates :category, presence: true
end
