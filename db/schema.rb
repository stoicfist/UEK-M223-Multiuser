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

ActiveRecord::Schema[8.0].define(version: 2025_09_25_063550) do
  create_table "documents", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "template_id", null: false
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_documents_on_template_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "visibility"
    t.text "description"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "pending_email"
    t.string "pending_email_token"
    t.datetime "pending_email_token_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["pending_email_token"], name: "index_users_on_pending_email_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "documents", "templates"
  add_foreign_key "documents", "users"
  add_foreign_key "templates", "users"
end
