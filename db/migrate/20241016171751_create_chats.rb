class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :customer_id
      t.integer :seller_id

      t.timestamps
    end
    add_index :chats, [:customer_id, :seller_id], unique: true
  end
end
