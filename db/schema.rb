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

ActiveRecord::Schema[8.0].define(version: 2025_08_14_054628) do
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

  create_table "associates", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.integer "shares_count"
    t.decimal "initial_contribution"
    t.decimal "current_account_balance", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["company_id"], name: "index_associates_on_company_id"
    t.index ["email"], name: "index_associates_on_email", unique: true
    t.index ["reset_password_token"], name: "index_associates_on_reset_password_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_operations", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "property_id"
    t.integer "tenant_id"
    t.integer "associate_id"
    t.string "category"
    t.string "label"
    t.decimal "amount", precision: 10, scale: 2
    t.date "operation_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "operation_type"
    t.text "description"
    t.string "reference_number"
    t.json "metadata"
    t.index ["associate_id", "category"], name: "index_financial_operations_on_associate_id_and_category"
    t.index ["associate_id"], name: "index_financial_operations_on_associate_id"
    t.index ["category"], name: "index_financial_operations_on_category"
    t.index ["company_id", "category", "operation_date"], name: "idx_on_company_id_category_operation_date_9cfb5aa3fa"
    t.index ["company_id", "category"], name: "index_financial_operations_on_company_id_and_category"
    t.index ["company_id", "operation_date"], name: "index_financial_operations_on_company_id_and_operation_date"
    t.index ["company_id"], name: "index_financial_operations_on_company_id"
    t.index ["operation_date"], name: "index_financial_operations_on_operation_date"
    t.index ["operation_type"], name: "index_financial_operations_on_operation_type"
    t.index ["property_id", "operation_date"], name: "index_financial_operations_on_property_id_and_operation_date"
    t.index ["property_id"], name: "index_financial_operations_on_property_id"
    t.index ["tenant_id"], name: "index_financial_operations_on_tenant_id"
  end

  create_table "general_meetings", force: :cascade do |t|
    t.integer "company_id", null: false
    t.date "date"
    t.string "title"
    t.text "minutes_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_general_meetings_on_company_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "address"
    t.text "description"
    t.date "acquisition_date"
    t.decimal "acquisition_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_properties_on_company_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.integer "property_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.decimal "rent_amount"
    t.decimal "charges_amount"
    t.date "lease_start_date"
    t.date "lease_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_tenants_on_property_id"
  end

  add_foreign_key "associates", "companies"
  add_foreign_key "financial_operations", "associates"
  add_foreign_key "financial_operations", "companies"
  add_foreign_key "financial_operations", "properties"
  add_foreign_key "financial_operations", "tenants"
  add_foreign_key "general_meetings", "companies"
  add_foreign_key "properties", "companies"
  add_foreign_key "tenants", "properties"
end
