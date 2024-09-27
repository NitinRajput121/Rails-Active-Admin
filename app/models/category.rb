class Category < ApplicationRecord
    has_many :sub_categories, dependent: :destroy

    has_many :catalogues

    accepts_nested_attributes_for :sub_categories, allow_destroy: true

    def sub_categories_name
        sub_categories.map{ |s| s.name }
    end
end
