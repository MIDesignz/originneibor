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

ActiveRecord::Schema.define(version: 20171017051932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_filename"
    t.string   "image_url"
    t.string   "video_filename"
    t.string   "video_url"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "ip_address"
    t.string   "fetched_address"
    t.datetime "closed_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.boolean  "nonprofit_organization"
    t.boolean  "volunteers_required"
    t.integer  "status",                 default: 0
    t.boolean  "is_featured"
    t.integer  "targeted_amount"
    t.string   "youtube_link"
  end

  create_table "contributions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "donation_type"
    t.integer  "donation_amount"
    t.string   "currency_type"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "wepay_preapproval_id"
    t.integer  "campaign_id"
    t.string   "status",               default: "Pending"
    t.string   "preapproval_url"
  end

  create_table "faq_categories", force: :cascade do |t|
    t.string   "title"
    t.integer  "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.integer  "faq_category_id"
    t.string   "title"
    t.text     "description"
    t.integer  "priority"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "global_settings", force: :cascade do |t|
    t.string   "we_pay_client_id"
    t.string   "we_pay_client_secret"
    t.float    "commission_rate"
    t.boolean  "campaigns_require_approval"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.integer  "campaign_id"
    t.datetime "read_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notifications", ["campaign_id"], name: "index_notifications_on_campaign_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "ip_address"
    t.string   "address"
    t.string   "fetched_address"
    t.string   "wepay_access_token"
    t.string   "wepay_account_id"
    t.boolean  "wepay_account_status"
    t.string   "wepay_user_id"
    t.text     "roles",                  default: [],              array: true
    t.string   "wepay_updated_uri"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "image"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "banned"
    t.string   "mobile_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
