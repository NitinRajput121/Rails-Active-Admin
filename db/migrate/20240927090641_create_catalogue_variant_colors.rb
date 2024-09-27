class CreateCatalogueVariantColors < ActiveRecord::Migration[7.1]
  def change
    create_table :catalogue_variant_colors do |t|
      t.string :name
      t.string :color_code
      
      t.timestamps
    end
  end
end
