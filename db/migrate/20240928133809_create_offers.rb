class CreateOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :offers do |t|
      t.string :offer_name
      t.decimal :discount
      t.date :start_date
      t.date :end_date
      t.integer :catalogue_variant_id

      t.timestamps
    end
    add_index :offers, :catalogue_variant_id

  end
end
