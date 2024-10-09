ActiveAdmin.register OrderItem do
  permit_params :order_id, :catalogue_variant_id, :quantity

  index do
    selectable_column
    id_column
    column :order
    column :catalogue_variant do |order_item|
 
      order_item.catalogue_variant.catalogue.name if order_item.catalogue_variant.present?
    end
    column :quantity
    column :created_at
    
  end
end

