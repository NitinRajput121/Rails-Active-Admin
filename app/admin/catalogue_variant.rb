ActiveAdmin.register CatalogueVariant do

 permit_params :price, :catalogue_variant_color_id, :catalogue_variant_size_id, :quantity, :catalogue_id


 index do
    selectable_column
    id_column
    column :price
    column :quantity
    column :catalogue do |catalogue_variant|
        catalogue_variant.catalogue.name
        end
    column :catalogue_variant_color do |catalogue_variant|
        catalogue_variant.catalogue_variant_color.name
       end
    column :catalogue_variant_size do |catalogue_variant|
        catalogue_variant.catalogue_variant_size.name
      end   
    column :created_at
    actions
  end


  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do

        f.input :price
        f.input :catalogue_variant_color_id, as: :select, collection: CatalogueVariantColor.all.map { |c| [c.name, c.id] }
        f.input :catalogue_variant_size_id, as: :select, collection: CatalogueVariantSize.all.map { |s| [s.name, s.id] }
        f.input :quantity
        f.input :catalogue_id, as: :select, collection: Catalogue.all.map { |c| [c.name, c.id] }


    end
    f.actions
end


show do
    attributes_table do
      row :price
      row :quantity
      row :catalogue_id
      row :catalogue_variant_color do |catalogue_variant|
       catalogue_variant.catalogue_variant_color.name
      end
      row :catalogue_variant_size do |catalogue_variant|
        catalogue_variant.catalogue_variant_size.name
      end
      row :created_at
    end
  end


end