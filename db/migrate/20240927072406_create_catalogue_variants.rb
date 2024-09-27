class CreateCatalogueVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :catalogue_variants do |t|
      t.decimal :price
      t.integer :catalogue_variant_color_id
      t.integer :catalogue_variant_size_id
      t.integer :quantity
      t.integer :catalogue_id
      
      t.timestamps
    end
  end
end
