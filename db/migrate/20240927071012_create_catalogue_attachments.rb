class CreateCatalogueAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :catalogue_attachments do |t|
      t.integer :status
      t.bigint  :catalogue_variant_id
      
      t.timestamps
    end
  end
end
