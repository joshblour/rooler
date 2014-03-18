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

ActiveRecord::Schema.define(version: 20140318113047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "foos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "rooler_deliveries", force: true do |t|
    t.string   "deliverable_type"
    t.integer  "deliverable_id"
    t.integer  "rule_id"
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooler_rules", force: true do |t|
    t.string   "name"
    t.integer  "template_id"
    t.integer  "check_frequency"
    t.datetime "last_checked_at"
    t.string   "klass_name"
    t.string   "klass_finder_method"
    t.string   "instance_checker_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "method_params"
  end

  create_table "rooler_templates", force: true do |t|
    t.string   "name"
    t.string   "to"
    t.string   "cc"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
