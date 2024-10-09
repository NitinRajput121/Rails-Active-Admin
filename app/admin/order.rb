ActiveAdmin.register Order do

 permit_params :total_price, :status, :user_id


  index do
    selectable_column
    id_column
    column :user do |order|
      order.user&.name || "none"  # Assuming `Order` belongs_to `User` and `User` has a `name` field
    end
    column :total_price
    column :status
    column :created_at
     actions
  end


end

