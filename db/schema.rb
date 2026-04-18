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

ActiveRecord::Schema[8.1].define(version: 2023_10_22_170435) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "awards", force: :cascade do |t|
    t.string "name", null: false
    t.integer "product_id", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "address", null: false
    t.boolean "always_gets_case_deal", default: false, null: false
    t.string "contact_point"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "email"
    t.boolean "is_public", default: true, null: false
    t.string "name"
    t.integer "num_kegs", default: 0, null: false
    t.boolean "paperless_billing", default: false, null: false
    t.string "phone"
    t.boolean "pickup_check", default: true, null: false
    t.integer "sales_rep_id"
    t.integer "town_id"
    t.string "unit_number"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "xero_id"
    t.index ["name"], name: "index_contacts_on_name", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "resolution"
    t.datetime "resolved_at"
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "assigned_to_id"
    t.text "comments"
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.string "customer_po"
    t.datetime "deleted_at"
    t.boolean "delivered", default: false, null: false
    t.date "delivery_date"
    t.date "fulfilled_on"
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.string "xero_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "case_size", default: 12, null: false
    t.string "category", default: "Flagship", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "in_production", default: true, null: false
    t.boolean "is_public", default: true, null: false
    t.string "name"
    t.float "price_point"
    t.datetime "updated_at", null: false
    t.string "xero_code", null: false
    t.string "xero_id"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["xero_code"], name: "index_products_on_xero_code", unique: true
  end

  create_table "report_info", id: false, force: :cascade do |t|
    t.date "keg_report_calculated_on"
    t.integer "uuid", default: 1, null: false
    t.index ["uuid"], name: "index_report_info_on_uuid", unique: true
  end

  create_table "sales_reps", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "phone"
  end

  create_table "states", force: :cascade do |t|
    t.string "abbreviation"
    t.string "name"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.index ["name", "state_id"], name: "index_towns_on_name_and_state_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.boolean "receives_emails", default: true, null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.string "xeroAccessToken"
    t.string "xeroRefreshToken"
    t.string "xeroTenantId"
    t.string "xeroTokenExpiresAt"
    t.string "xeroUid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "xero_sync_errors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message"
    t.bigint "syncable_id"
    t.string "syncable_type"
    t.datetime "updated_at", null: false
    t.index ["syncable_type", "syncable_id"], name: "index_xero_sync_errors_on_syncable"
  end
end
