# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150316093448) do

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "parent_id"
    t.string   "ancestry"
    t.string   "layout_name"
    t.text     "custom_layout_content"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry"
  add_index "pages", ["slug"], name: "index_pages_on_slug"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
