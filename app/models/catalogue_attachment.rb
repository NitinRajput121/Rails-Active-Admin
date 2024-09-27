class CatalogueAttachment < ApplicationRecord
  has_one_attached :media, dependent: :destroy
  belongs_to :catalogue_variant

  enum status: { :pending => 0, :approved => 1, :rejected => 2 }
end
