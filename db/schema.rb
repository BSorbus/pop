# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150521195849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "short",               limit: 10,  default: "",    null: false
    t.string   "name",                limit: 100, default: "",    null: false
    t.string   "address_city",        limit: 50,  default: "",    null: false
    t.string   "address_street",      limit: 50
    t.string   "address_house",       limit: 10
    t.string   "address_number",      limit: 10
    t.string   "address_postal_code", limit: 6
    t.string   "phone",               limit: 50
    t.string   "email",               limit: 50
    t.string   "nip",                 limit: 13
    t.string   "regon",               limit: 9
    t.string   "pesel",               limit: 11
    t.boolean  "informal_group",                  default: false, null: false
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["address_city"], name: "index_companies_on_address_city", using: :btree
  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree
  add_index "companies", ["short", "user_id"], name: "index_companies_on_short_and_user_id", unique: true, using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_histories", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "short"
    t.string   "name"
    t.string   "address_city"
    t.string   "address_street"
    t.string   "address_house"
    t.string   "address_number"
    t.string   "address_postal_code"
    t.string   "phone"
    t.string   "email"
    t.string   "nip"
    t.string   "regon"
    t.string   "pesel"
    t.boolean  "informal_group"
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "company_histories", ["company_id"], name: "index_company_histories_on_company_id", using: :btree

  create_table "coverages", force: :cascade do |t|
    t.integer  "rotation_id"
    t.integer  "group_id"
    t.integer  "insured_id"
    t.integer  "payer_id"
    t.text     "note"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "coverages", ["group_id"], name: "index_coverages_on_group_id", using: :btree
  add_index "coverages", ["insured_id"], name: "index_coverages_on_insured_id", using: :btree
  add_index "coverages", ["payer_id"], name: "index_coverages_on_payer_id", using: :btree
  add_index "coverages", ["rotation_id", "insured_id", "payer_id"], name: "index_coverages_on_rotation_id_and_insured_id_and_payer_id", unique: true, using: :btree
  add_index "coverages", ["rotation_id"], name: "index_coverages_on_rotation_id", using: :btree

  create_table "discounts", force: :cascade do |t|
    t.string   "category",                                   default: "",  null: false
    t.string   "description"
    t.decimal  "discount_increase", precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discounts", ["group_id"], name: "index_discounts_on_group_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.boolean  "allday"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "color"
    t.string   "url_action"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["end_date"], name: "index_events_on_end_date", using: :btree
  add_index "events", ["start_date"], name: "index_events_on_start_date", using: :btree
  add_index "events", ["url_action"], name: "index_events_on_url_action", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.integer  "number",                                        default: 0,     null: false
    t.string   "quotation",                                     default: "A",   null: false
    t.boolean  "tariff_fixed",                                  default: false, null: false
    t.boolean  "full_range",                                    default: false, null: false
    t.string   "risk_group",                                    default: "A",   null: false
    t.decimal  "assurance",            precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "assurance_component",  precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "treatment",            precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "treatment_component",  precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "ambulatory",           precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "ambulatory_component", precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "hospital",             precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "hospital_component",   precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "infarct",              precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "infarct_component",    precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "inability",            precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "inability_component",  precision: 10, scale: 2, default: 0.0,   null: false
    t.boolean  "death_100_percent",                             default: false, null: false
    t.decimal  "sum_component",        precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "sum_after_discounts",  precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "sum_after_increases",  precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "sum_after_monthly",    precision: 10, scale: 2, default: 0.0,   null: false
    t.integer  "insurance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["insurance_id"], name: "index_groups_on_insurance_id", using: :btree

  create_table "individual_histories", force: :cascade do |t|
    t.integer  "individual_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "address_city"
    t.string   "address_street"
    t.string   "address_house"
    t.string   "address_number"
    t.string   "address_postal_code"
    t.string   "pesel"
    t.date     "birth_date"
    t.string   "profession"
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "individual_histories", ["individual_id"], name: "index_individual_histories_on_individual_id", using: :btree

  create_table "individuals", force: :cascade do |t|
    t.string   "last_name",           limit: 80, default: "", null: false
    t.string   "first_name",          limit: 30, default: "", null: false
    t.string   "address_city",        limit: 50, default: "", null: false
    t.string   "address_street",      limit: 50
    t.string   "address_house",       limit: 10
    t.string   "address_number",      limit: 10
    t.string   "address_postal_code", limit: 6
    t.string   "pesel",               limit: 11
    t.date     "birth_date"
    t.string   "profession",          limit: 50
    t.text     "note"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "individuals", ["address_city"], name: "index_individuals_on_address_city", using: :btree
  add_index "individuals", ["first_name"], name: "index_individuals_on_first_name", using: :btree
  add_index "individuals", ["last_name"], name: "index_individuals_on_last_name", using: :btree
  add_index "individuals", ["pesel"], name: "index_individuals_on_pesel", using: :btree
  add_index "individuals", ["user_id"], name: "index_individuals_on_user_id", using: :btree

  create_table "insurance_histories", force: :cascade do |t|
    t.integer  "insurance_id"
    t.string   "number"
    t.date     "concluded"
    t.date     "valid_from"
    t.date     "applies_to"
    t.string   "pay"
    t.boolean  "insurance_lock"
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurance_histories", ["insurance_id"], name: "index_insurance_histories_on_insurance_id", using: :btree

  create_table "insurances", force: :cascade do |t|
    t.string   "number",         default: "",    null: false
    t.date     "concluded",                      null: false
    t.date     "valid_from",                     null: false
    t.date     "applies_to"
    t.string   "pay",            default: "R",   null: false
    t.boolean  "insurance_lock", default: false, null: false
    t.text     "note"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurances", ["company_id"], name: "index_insurances_on_company_id", using: :btree
  add_index "insurances", ["concluded"], name: "index_insurances_on_concluded", using: :btree
  add_index "insurances", ["number", "user_id"], name: "index_insurances_on_number_and_user_id", unique: true, using: :btree
  add_index "insurances", ["user_id"], name: "index_insurances_on_user_id", using: :btree

  create_table "rotation_histories", force: :cascade do |t|
    t.integer  "rotation_id"
    t.date     "rotation_date"
    t.boolean  "rotation_lock"
    t.date     "date_file_send"
    t.text     "note"
    t.integer  "insurance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rotation_histories", ["rotation_id"], name: "index_rotation_histories_on_rotation_id", using: :btree

  create_table "rotations", force: :cascade do |t|
    t.date     "rotation_date",                  null: false
    t.boolean  "rotation_lock",  default: false, null: false
    t.date     "date_file_send"
    t.text     "note"
    t.integer  "insurance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rotations", ["insurance_id"], name: "index_rotations_on_insurance_id", using: :btree
  add_index "rotations", ["rotation_date"], name: "index_rotations_on_rotation_date", using: :btree

  create_table "tariffs", force: :cascade do |t|
    t.string   "category"
    t.string   "description"
    t.string   "quotation"
    t.boolean  "tariff_fixed"
    t.boolean  "full_range"
    t.string   "risk_group"
    t.string   "pay"
    t.boolean  "informal_group"
    t.integer  "condition_int"
    t.string   "condition_str"
    t.decimal  "tariff_percent", precision: 10, scale: 2
    t.decimal  "tariff_value",   precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "agent_number",           default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "address",                default: ""
    t.boolean  "is_admin",               default: false, null: false
    t.boolean  "approved",               default: false, null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["agent_number"], name: "index_users_on_agent_number", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "companies", "users"
  add_foreign_key "coverages", "groups"
  add_foreign_key "coverages", "individuals", column: "insured_id"
  add_foreign_key "coverages", "individuals", column: "payer_id"
  add_foreign_key "coverages", "rotations"
  add_foreign_key "discounts", "groups"
  add_foreign_key "groups", "insurances"
  add_foreign_key "individuals", "users"
  add_foreign_key "insurances", "companies"
  add_foreign_key "insurances", "users"
  add_foreign_key "rotations", "insurances"
end
