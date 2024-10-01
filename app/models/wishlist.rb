class Wishlist < ApplicationRecord
    belongs_to :user
    belongs_to :catalogue
    belongs_to :catalogue_variant
end         