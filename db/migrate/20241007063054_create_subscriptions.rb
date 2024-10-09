class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
    t.integer "plan_id"
    t.integer "user_id"
    t.datetime "started_at"
    t.datetime "expires_at"
      t.timestamps
    end
  end
end
