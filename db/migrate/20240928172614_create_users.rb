class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :digested_password
      t.string :user_type
      t.string :authentication_type
      t.integer :country_code
      t.bigint :phone_number

      t.timestamps
    end
  end
end
