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

ActiveRecord::Schema.define(version: 2020_05_06_161954) do

  create_table "channels", force: :cascade do |t|
    t.string "channel"
    t.integer "platform_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "member_id"
    t.index ["member_id"], name: "index_channels_on_member_id"
    t.index ["platform_id"], name: "index_channels_on_platform_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string "platform"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room"
    t.integer "platform_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_rooms_on_platform_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "video"
    t.integer "duration"
    t.integer "platform_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_videos_on_platform_id"
  end

  add_foreign_key "channels", "members"
  add_foreign_key "channels", "platforms"
  add_foreign_key "rooms", "platforms"
  add_foreign_key "videos", "platforms"
end
