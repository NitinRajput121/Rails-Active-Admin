ActiveAdmin.register Plan do
  permit_params :name, :duration, :price_monthly, :price_yearly, :discount, :discount_type, 
                :discount_percentage, :details, :plan_type, :active, :available

  # Index View customization
  index do
    selectable_column
    id_column
    column :name
    column :plan_type
    column :price_monthly
    column :price_yearly
    column :discount
    column :discount_percentage
    column :active
    actions
  end

  # Show View customization
  show do
    attributes_table do
      row :name
      row :plan_type
      row :price_monthly
      row :price_yearly
      row :discount
      row :discount_type
      row :discount_percentage
      row :details
      row :active
      row :available
      row :created_at
      row :updated_at
    end
  end

  # Form customization
  form do |f|
    f.inputs do
      f.input :name
      f.input :duration
      f.input :plan_type, as: :select, collection: [["Free", "free"], ["Paid", "paid"]], input_html: { id: 'plan_type' }
      f.input :details
      f.input :price_monthly, input_html: { id: 'price_monthly' }
      f.input :price_yearly, input_html: { id: 'price_yearly' }
      f.input :discount, as: :select, collection: [["No", false], ["Yes", true]], input_html: { id: 'discount' }
      f.input :discount_type, as: :select, collection: ["Percentage", "Fixed"], input_html: { id: 'discount_type' }
      f.input :discount_percentage, input_html: { id: 'discount_percentage' }
      f.input :active
      f.input :available
    end
    f.actions
  end
end
