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

ActiveRecord::Schema.define(version: 20140307044616) do

  create_table "ipaddresses", force: true do |t|
    t.string   "ip_address"
    t.string   "interface"
    t.integer  "virtualmachine_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_interfaces", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "virtualmachines", force: true do |t|
    t.integer  "Template"
    t.string   "Label"
    t.string   "Hostname"
    t.integer  "HypervisorZID"
    t.integer  "HypervisorID"
    t.string   "Password"
    t.string   "PasswordConfirmation"
    t.integer  "Ram"
    t.integer  "CpuCore"
    t.integer  "CpuPrio"
    t.integer  "DSpZone"
    t.integer  "PDSize"
    t.integer  "DSsZone"
    t.integer  "SDSize"
    t.integer  "NetZone"
    t.integer  "PortSpeed"
    t.boolean  "EAB",                  default: false
    t.boolean  "BVS",                  default: true
    t.boolean  "BootVS",               default: false
    t.integer  "RemoteID"
    t.string   "LabelOS"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
