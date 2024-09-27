class CreateCatalogues < ActiveRecord::Migration[7.1]
  def change
    create_table :catalogues do |t|
      t.string :name
      t.text :description
      t.integer :gender
      t.integer :category_id
      t.integer :sub_category_id

      t.timestamps
    end
    add_index :catalogues, :category_id
    add_index :catalogues, :sub_category_id
   
  end
end
