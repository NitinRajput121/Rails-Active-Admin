class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.integer :user_id, null: true
      t.string :token, null: true

      t.timestamps
    end
     add_index :carts, :token, unique: true
  end
end
