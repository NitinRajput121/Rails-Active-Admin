class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.integer :order_id, null: false
      t.integer :catalogue_variant_id, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
