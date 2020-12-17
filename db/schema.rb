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

ActiveRecord::Schema.define(version: 2020_12_15_105507) do

  create_table "hashtags", force: :cascade do |t|
    t.string "tag", limit: 20, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag"], name: "index_hashtags_on_tag", unique: true
  end

  create_table "hashtags_questions", id: false, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "hashtag_id", null: false
    t.index ["hashtag_id"], name: "index_hashtags_questions_on_hashtag_id"
    t.index ["question_id"], name: "index_hashtags_questions_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "author_id"
    t.index ["author_id"], name: "index_questions_on_author_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "password_hash"
    t.string "password_salt"
    t.string "avatar_url"
    t.string "background_color", limit: 7, default: "#005a55"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "questions", "users"
  add_foreign_key "questions", "users", column: "author_id"
end
