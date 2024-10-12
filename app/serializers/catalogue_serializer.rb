
class CatalogueSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :gender

  attribute :catalogue_variants do |object, params|
      serializer = CatalogueVariantSerializer.new(
        object.catalogue_variants, { params: params }
      )
      serializer.serializable_hash[:data]
    end
end




