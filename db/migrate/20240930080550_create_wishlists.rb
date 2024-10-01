class CreateWishlists < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlists do |t|
      t.integer :user_id 
      t.integer :catalogue_variant_id
      t.integer :catalogue_id

      t.timestamps
    end
  end
end
