# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_03_20_004940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clicks", force: :cascade do |t|
    t.bigint "shortened_url_id"
    t.string "ip_address"
    t.string "user_agent"
    t.string "referrer"
    t.string "geolocation"
    t.string "device_type"
    t.string "browser"
    t.string "os"
    t.string "country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shortened_url_id"], name: "index_clicks_on_shortened_url_id"
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.string "original_url", null: false
    t.string "backhalf", limit: 15, null: false
    t.string "title", limit: 300
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["backhalf"], name: "index_shortened_urls_on_backhalf"
    t.index ["original_url", "backhalf"], name: "uk_original_url_backhalf", unique: true
  end

  add_foreign_key "clicks", "shortened_urls"
end
