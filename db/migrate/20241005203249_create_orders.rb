class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :total_price, precision: 10, scale: 2
      t.string :status, default: 'pending'
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
