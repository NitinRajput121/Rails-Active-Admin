class CatalogueVariantSize < ApplicationRecord
	has_many :catalogue_variants, dependent: :destroy
end
