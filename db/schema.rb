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

ActiveRecord::Schema.define(version: 2021_07_07_212747) do

  create_table "integrations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "kind", null: false
    t.text "data", null: false
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.text "description"
    t.integer "rating"
    t.bigint "server_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_reviews_on_server_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "servers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "name", null: false
    t.text "description", null: false
    t.text "banner"
    t.string "java_ip", limit: 128, null: false
    t.string "bedrock_ip", limit: 128, null: false
    t.text "discord"
    t.text "website"
    t.timestamp "created", default: -> { "current_timestamp()" }, null: false
    t.timestamp "updated", default: -> { "current_timestamp()" }, null: false
    t.index ["bedrock_ip"], name: "bedrock_ip", unique: true
    t.index ["java_ip"], name: "java_ip", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "username", limit: 32, null: false
    t.text "access_token", null: false
    t.timestamp "creation", default: -> { "current_timestamp()" }, null: false
    t.integer "status", default: 0, null: false
    t.index ["id"], name: "id", unique: true
    t.index ["username"], name: "username", unique: true
  end

end
