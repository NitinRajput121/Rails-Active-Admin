# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_16_172928) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "catalogue_variant_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_carts_on_token", unique: true
  end

  create_table "catalogue_attachments", force: :cascade do |t|
    t.integer "status"
    t.bigint "catalogue_variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.string "color_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.decimal "price"
    t.integer "catalogue_variant_color_id"
    t.integer "catalogue_variant_size_id"
    t.integer "quantity"
    t.integer "catalogue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catalogues", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "gender"
    t.integer "category_id"
    t.integer "sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "seller_id"], name: "index_chats_on_customer_id_and_seller_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_id"
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", force: :cascade do |t|
    t.string "offer_name"
    t.decimal "discount"
    t.date "start_date"
    t.date "end_date"
    t.integer "catalogue_variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalogue_variant_id"], name: "index_offers_on_catalogue_variant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "catalogue_variant_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "total_price", precision: 10, scale: 2
    t.string "status", default: "pending"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "user_id"
    t.datetime "started_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "user_type"
    t.string "stripe_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wishlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "catalogue_variant_id"
    t.integer "catalogue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
