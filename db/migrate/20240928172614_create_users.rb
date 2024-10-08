class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :user_type
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
