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

ActiveRecord::Schema.define(version: 2020_08_08_133128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "adminpack"
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "description"
    t.float "odds"
    t.string "game_name"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_actions_on_room_id"
  end

  create_table "bets", force: :cascade do |t|
    t.string "description"
    t.float "odds"
    t.string "game_name"
    t.integer "wager_amount"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["room_id"], name: "index_bets_on_room_id"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "room_id"
    t.datetime "creation_time"
    t.text "current_users", default: [], array: true
    t.text "alltime_users", default: [], array: true
    t.integer "max_bet"
    t.integer "max_users"
    t.integer "min_bet"
    t.string "game_name"
    t.integer "host_id"
    t.boolean "locked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_state"
    t.integer "house_wallet"
    t.bigint "users_id"
    t.index ["users_id"], name: "index_rooms_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_balance"
    t.integer "birth_time"
    t.bigint "room_id"
    t.index ["room_id"], name: "index_users_on_room_id"
  end

  add_foreign_key "actions", "rooms"
  add_foreign_key "bets", "rooms"
  add_foreign_key "bets", "users"
  add_foreign_key "rooms", "users", column: "users_id"
  add_foreign_key "users", "rooms"
end
