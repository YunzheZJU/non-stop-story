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

ActiveRecord::Schema.define(version: 2020_05_07_180250) do

  create_table "archives", force: :cascade do |t|
    t.integer "duration"
    t.integer "live_id"
    t.integer "video_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["live_id"], name: "index_archives_on_live_id"
    t.index ["video_id"], name: "index_archives_on_video_id"
  end

  create_table "arranges", force: :cascade do |t|
    t.integer "video_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["video_id"], name: "index_arranges_on_video_id"
  end

  create_table "arranges_clips", id: false, force: :cascade do |t|
    t.integer "arrange_id"
    t.integer "clip_id"
    t.index ["arrange_id"], name: "index_arranges_clips_on_arrange_id"
    t.index ["clip_id"], name: "index_arranges_clips_on_clip_id"
  end

  create_table "arranges_editors", id: false, force: :cascade do |t|
    t.integer "arrange_id"
    t.integer "editor_id"
    t.index ["arrange_id"], name: "index_arranges_editors_on_arrange_id"
    t.index ["editor_id"], name: "index_arranges_editors_on_editor_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "channel"
    t.integer "platform_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "member_id"
    t.integer "editor_id"
    t.index ["editor_id"], name: "index_channels_on_editor_id"
    t.index ["member_id"], name: "index_channels_on_member_id"
    t.index ["platform_id"], name: "index_channels_on_platform_id"
  end

  create_table "clips", force: :cascade do |t|
    t.integer "in_time"
    t.integer "out_time"
    t.integer "live_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["live_id"], name: "index_clips_on_live_id"
  end

  create_table "editors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lives", force: :cascade do |t|
    t.string "title"
    t.datetime "start_at"
    t.integer "member_id"
    t.integer "room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "duration"
    t.integer "video_id"
    t.index ["member_id"], name: "index_lives_on_member_id"
    t.index ["room_id"], name: "index_lives_on_room_id"
    t.index ["video_id"], name: "index_lives_on_video_id"
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
    t.string "title"
    t.index ["platform_id"], name: "index_videos_on_platform_id"
  end

  add_foreign_key "archives", "lives"
  add_foreign_key "archives", "videos"
  add_foreign_key "arranges", "videos"
  add_foreign_key "channels", "editors"
  add_foreign_key "channels", "members"
  add_foreign_key "channels", "platforms"
  add_foreign_key "clips", "lives"
  add_foreign_key "lives", "members"
  add_foreign_key "lives", "rooms"
  add_foreign_key "lives", "videos"
  add_foreign_key "rooms", "platforms"
  add_foreign_key "videos", "platforms"
end
