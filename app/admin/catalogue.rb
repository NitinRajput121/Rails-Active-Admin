ActiveAdmin.register Catalogue do
  permit_params :name, :description, :gender, :category_id, :sub_category_id,
  catalogue_variants_attributes: [
    :id, :price, :catalogue_variant_color_id, :catalogue_variant_size_id, :quantity, :_destroy,
    attachments_attributes: [
      :id, :media, :status, :catalogue_variant_id, :_destroy
    ]
  ]

  filter :name
  filter :gender, as: :select, collection: Catalogue.genders.map { |key, value| [key.to_s.titleize, value] }

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :gender
    column :category do |catalogue|
      catalogue.category.name
    end
    column :subcategory do |catalogue|
      catalogue. sub_category.name
    end
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
      f.input :description
      f.input :gender, as: :select, collection: Catalogue.genders.keys.map { |gender| [gender.capitalize, gender] }
      f.input :category_id, as: :select, collection: Category.all.map { |category| [category.name, category.id] }
      f.input :sub_category_id, as: :select, collection: SubCategory.all.map { |subcategory| [subcategory.name, subcategory.id] }
    end
  
    f.inputs do
      f.has_many :catalogue_variants, allow_destroy: true, new_record: 'Add Variant', heading: 'Catalogue Variants' do |ff|
        ff.input :price
        ff.input :catalogue_variant_color_id, as: :select, collection: CatalogueVariantColor.all.map { |c| [c.name, c.id] }
        ff.input :catalogue_variant_size_id, as: :select, collection: CatalogueVariantSize.all.map { |s| [s.name, s.id] }
        ff.input :quantity
  
        ff.has_many :attachments, allow_destroy: true, new_record: "Add Attachment", remove_record: 'Remove Attachment' do |attachment|
          attachment.input :media, as: :file, input_html: { multiple: false }
        end
      end
    end
  
    f.actions
  end
  

  show do
    attributes_table do
      row :name
      row :description
      row :gender do |catalogue|
        catalogue.gender.capitalize
      end
      row :created_at
      row :category do |catalogue|
        catalogue.category.name
      end
      row :subcategory do |catalogue|
        catalogue. sub_category.name
      end
    end
  end
end













