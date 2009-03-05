# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090304231437) do

  create_table "configurations", :force => true do |t|
    t.datetime "deadline"
    t.integer  "max_team_score"
    t.integer  "max_student_score"
    t.text     "right_hand_information"
    t.text     "confirmation_email"
    t.integer  "test_scores_to_count"
    t.integer  "max_students_on_team"
    t.integer  "team_test_points_per_question"
    t.integer  "large_school_cutoff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proctors", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "contact_phone"
    t.string   "contact_name"
    t.integer  "enrollment"
    t.boolean  "admin",             :default => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.datetime "current_login"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",  :default => "",    :null => false
    t.integer  "school_score"
  end

  add_index "schools", ["perishable_token"], :name => "index_schools_on_perishable_token"

  create_table "students", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_score"
  end

  create_table "teams", :force => true do |t|
    t.integer  "school_id"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_score"
    t.integer  "students_count",         :default => 0
    t.boolean  "test_score_checked"
    t.boolean  "team_score_checked"
    t.boolean  "student_scores_checked"
    t.boolean  "is_exhibition"
    t.integer  "team_score"
  end

end
