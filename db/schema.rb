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

ActiveRecord::Schema[8.0].define(version: 2026_07_02_140132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "astuces", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "images", default: [], array: true
    t.string "category", default: "Général"
    t.bigint "product_id"
    t.boolean "active", default: true, null: false
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_astuces_on_product_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name_fr"
    t.string "name_ar"
    t.string "name_en"
    t.text "description"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_requests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.text "message"
    t.bigint "product_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_requested"
    t.index ["product_id"], name: "index_contact_requests_on_product_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code", null: false
    t.string "discount_type", null: false
    t.decimal "discount_value", precision: 10, scale: 2, null: false
    t.decimal "min_order_amount", precision: 10, scale: 2, default: "0.0"
    t.integer "max_uses"
    t.integer "used_count", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question", null: false
    t.text "answer", null: false
    t.string "category", default: "Général"
    t.integer "sort_order", default: 0
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marques", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "user_email", null: false
    t.jsonb "items", default: []
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "delivery_fee", precision: 10, scale: 2, default: "8.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "pending"
    t.string "payment_method", default: "cod"
    t.jsonb "delivery_address", default: {}
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coupon_code"
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_subcategories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "subcategory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_subcategories_on_product_id"
    t.index ["subcategory_id"], name: "index_product_subcategories_on_subcategory_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name_fr"
    t.string "name_ar"
    t.string "name_en"
    t.text "description_fr"
    t.text "description_ar"
    t.text "description_en"
    t.bigint "category_id"
    t.integer "stock_quantity", default: 0
    t.text "images", default: [], array: true
    t.date "manufacture_date"
    t.date "expiration_date"
    t.boolean "has_promotion", default: false
    t.integer "promotion_discount", default: 0
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "views_count", default: 0, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "marque_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["marque_id"], name: "index_products_on_marque_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "value", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "slider_images", force: :cascade do |t|
    t.string "title", default: ""
    t.string "subtitle", default: ""
    t.string "image_url", null: false
    t.string "link_url", default: ""
    t.string "link_label", default: ""
    t.integer "sort_order", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcategories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name_fr"
    t.string "name_ar"
    t.string "name_en"
    t.text "description"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.string "phone", default: ""
    t.string "role", default: "client"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "astuces", "products"
  add_foreign_key "contact_requests", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "product_subcategories", "products"
  add_foreign_key "product_subcategories", "subcategories"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "marques"
  add_foreign_key "reviews", "orders"
  add_foreign_key "reviews", "users"
  add_foreign_key "subcategories", "categories"
end
