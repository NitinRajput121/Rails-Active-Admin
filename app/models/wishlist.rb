class Wishlist < ApplicationRecord
    belongs_to :account
    belongs_to :catalogue
    belongs_to :catalogue_variant
end         