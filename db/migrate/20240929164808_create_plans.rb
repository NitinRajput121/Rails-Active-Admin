class CreatePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plans do |t|
    t.string "name"
    t.integer "duration"
    t.float "price"
    t.text "details"
    t.integer "plan_type"
    t.integer "months"
    t.decimal "price_monthly", precision: 10, scale: 2
    t.decimal "price_yearly", precision: 10, scale: 2
    t.integer "limit"
    t.integer "limit_type"
    t.boolean "discount", default: false
    t.string "discount_type"
    t.integer "discount_percentage", default: 0
    t.text "benefits"
    t.boolean "coming_soon", default: false
    t.boolean "active", default: true
    t.boolean "available", default: true
    t.float "discounted_price_mon"

      t.timestamps
    end
  end
end
