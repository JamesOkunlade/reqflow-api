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

ActiveRecord::Schema[7.1].define(version: 2024_06_26_184517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "approval_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_approval_users_on_approval_id"
    t.index ["user_id"], name: "index_approval_users_on_user_id"
  end

  create_table "approvals", force: :cascade do |t|
    t.decimal "approved_amount", precision: 10, scale: 2
    t.string "status"
    t.datetime "approved_at"
    t.datetime "confirmed_at"
    t.integer "confirmed_by_id"
    t.bigint "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_approvals_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "clearance_level", default: 1, null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "approval_users", "approvals"
  add_foreign_key "approval_users", "users"
  add_foreign_key "approvals", "requests"
  add_foreign_key "requests", "users"
end
