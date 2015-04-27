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

ActiveRecord::Schema.define(version: 20150422155705) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendars", force: :cascade do |t|
    t.integer  "eventId"
    t.date     "startDate"
    t.time     "startTime"
    t.date     "endDate"
    t.time     "endTime"
    t.string   "titleLong"
    t.string   "titleLink"
    t.text     "locationText"
    t.text     "sponsorText"
    t.text     "contactNameText"
    t.string   "contactEmail"
    t.string   "contactPhone"
    t.string   "eventType"
    t.string   "originatingCalendarName"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

  create_table "newsitems", force: :cascade do |t|
    t.string   "headline",               limit: 255
    t.text     "summary"
    t.text     "text"
    t.string   "image_url",              limit: 255
    t.integer  "published",              limit: 1,   default: 1
    t.datetime "publication_date"
    t.string   "departments",            limit: 255
    t.string   "category",               limit: 255
    t.string   "updated_by",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author",                 limit: 255
    t.string   "image_mcb_file_name",    limit: 255
    t.string   "image_mcb_content_type", limit: 255
    t.integer  "image_mcb_file_size",    limit: 11
    t.datetime "image_mcb_updated_at"
    t.string   "image_cdb_file_name",    limit: 255
    t.string   "image_cdb_content_type", limit: 255
    t.integer  "image_cdb_file_size",    limit: 11
    t.datetime "image_cdb_updated_at"
    t.text     "image_mcb_caption"
    t.text     "image_cdb_caption"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
