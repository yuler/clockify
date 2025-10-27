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

ActiveRecord::Schema[8.0].define(version: 2025_10_27_080000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "numerical_tasks", force: :cascade do |t|
    t.decimal "value", precision: 10, scale: 2, default: "0.0", null: false
    t.string "value_unit", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "task_entries", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.string "operation", limit: 20, null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.decimal "value_before", precision: 10, scale: 2, null: false
    t.decimal "value_after", precision: 10, scale: 2, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_task_entries_on_created_at"
    t.index ["task_id", "created_at"], name: "index_task_entries_on_task_id_and_created_at"
    t.index ["task_id"], name: "index_task_entries_on_task_id"
    t.index ["user_id", "created_at"], name: "index_task_entries_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_task_entries_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "emoji", limit: 8
    t.string "background", limit: 7
    t.string "name", limit: 20, null: false
    t.text "slogan"
    t.string "status", limit: 20, default: "active", null: false
    t.string "taskable_type", null: false
    t.bigint "taskable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taskable_type", "taskable_id"], name: "index_tasks_on_taskable"
    t.index ["user_id", "status"], name: "index_tasks_on_user_id_and_status"
    t.index ["user_id", "taskable_type"], name: "index_tasks_on_user_id_and_taskable_type"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "task_entries", "tasks"
  add_foreign_key "task_entries", "users"
  add_foreign_key "tasks", "users"
end
