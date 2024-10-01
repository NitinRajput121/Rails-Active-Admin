class CatalogueSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at

   
  has_many :catalogue_variants, if: -> { object.catalogue_variants.any? }

    attribute :category do |object| 
       object.object.category.name
    end 



     attribute :sub_category do |object| 
       object.object.sub_category.name 
    end 

end
