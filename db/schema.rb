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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130713125606) do

  create_table "doses", :force => true do |t|
    t.decimal  "total_quantity"
    t.integer  "number_of_cycles"
    t.decimal  "pause_between_cycles"
    t.string   "worker"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "status"
    t.datetime "finished_at"
  end

  create_table "readings", :force => true do |t|
    t.decimal  "value"
    t.integer  "sensor_id"
    t.datetime "measured_at"
  end

  create_table "sensors", :force => true do |t|
    t.string "name"
    t.string "unit"
  end

end
