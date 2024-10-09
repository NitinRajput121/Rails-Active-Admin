ActiveAdmin.register Category do
  permit_params :name, sub_categories_attributes: [ :id, :name, :category_id ]

  index do
    selectable_column
    id_column
    column :name
    column :sub_categories_name
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
    end

    f.has_many :sub_categories,
               heading: true,
               new_record: 'Create Subcategory',
               remove_record: 'Remove Subcategory',
               allow_destroy: true do |ff|
      ff.input :name
    end
   

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :sub_categories_name
      row :created_at
    end
  end
end