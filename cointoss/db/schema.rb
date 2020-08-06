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

ActiveRecord::Schema.define(version: 2020_08_06_003350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.json "active_actions", default: [], array: true
    t.json "alltime_actions", default: [], array: true
    t.json "active_bets", default: [], array: true
    t.json "alltime_bets", default: [], array: true
    t.integer "room_state"
    t.integer "house_wallet"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_balance"
    t.integer "birth_time"
  end

end
