# ActiveAdmin.register Wishlist do



# end

ActiveAdmin.register Wishlist do
  # Permit the parameters you want to allow in the form
  permit_params :user_id, :catalogue_variant_id, :catalogue_id

  # Customize the index page table
  index do
    selectable_column
    id_column
    column "User" do |wishlist|
      wishlist.user.email # Display the user's email instead of user_id
    end
    column :catalogue_variant_id
    column :catalogue_id
    column :created_at
    column :updated_at
    actions
  end

  # Customize the filters in the sidebar
  filter :user_id
  filter :catalogue_variant_id
  filter :catalogue_id
  filter :created_at
  filter :updated_at

  # Show page customization
  show do
    attributes_table do
      row :id
      row :user do |wishlist|
        wishlist.user.email # Display the user's email
      end
      row :catalogue_variant_id
      row :catalogue_id
      row :created_at
      row :updated_at
    end
  end

  # Customize the form for creating/editing wishlists
  form do |f|
    f.inputs "Wishlist Details" do
      f.input :user_id, label: 'User', as: :select, collection: User.pluck(:email, :id)
      f.input :catalogue_variant_id
      f.input :catalogue_id
    end
    f.actions
  end
end
