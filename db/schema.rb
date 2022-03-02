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

ActiveRecord::Schema[7.0].define(version: 2022_03_02_171338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.string "name", null: false
    t.integer "product_id", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "contact_point"
    t.text "address"
    t.text "description"
    t.datetime "deleted_at"
    t.integer "town_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.boolean "pickup_check", default: true, null: false
    t.string "xero_id"
    t.boolean "paperless_billing", default: false, null: false
    t.boolean "always_gets_case_deal", default: false, null: false
    t.boolean "is_public", default: true, null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.integer "created_by_id"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "resolution"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.boolean "delivered", default: false, null: false
    t.date "delivery_date"
    t.date "fulfilled_on"
    t.datetime "deleted_at"
    t.string "customer_po"
    t.text "comments"
    t.integer "created_by_id", null: false
    t.integer "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xero_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price_point"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "Flagship", null: false
    t.boolean "is_public", default: true, null: false
    t.integer "case_size", default: 12, null: false
    t.string "xero_id"
    t.string "xero_code", null: false
    t.boolean "in_production", default: true, null: false
    t.index ["xero_code"], name: "index_products_on_xero_code", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.index ["name", "state_id"], name: "index_towns_on_name_and_state_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xeroUid"
    t.string "xeroAccessToken"
    t.string "xeroRefreshToken"
    t.string "xeroTenantId"
    t.string "xeroTokenExpiresAt"
    t.string "role", null: false
    t.integer "contact_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "xero_sync_errors", force: :cascade do |t|
    t.string "message"
    t.string "syncable_type"
    t.bigint "syncable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["syncable_type", "syncable_id"], name: "index_xero_sync_errors_on_syncable"
  end

end
