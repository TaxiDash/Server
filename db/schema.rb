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

ActiveRecord::Schema.define(version: 20140206021513) do

  create_table "drivers", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "dob"
    t.string   "type_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "race"
    t.string   "sex"
    t.integer  "height"
    t.integer  "weight"
    t.string   "license"
    t.integer  "phone_number"
    t.date     "training_completion_date"
    t.date     "permit_expiration_date"
    t.integer  "permit_number"
    t.string   "status"
    t.string   "owner"
    t.string   "company_name"
    t.date     "physical_expiration_date"
    t.boolean  "valid"
    t.string   "beacon_id"
    t.decimal  "average_rating"
    t.integer  "total_ratings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "driver_id"
    t.integer  "rating"
    t.string   "comments"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
