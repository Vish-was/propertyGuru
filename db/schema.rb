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

ActiveRecord::Schema.define(version: 20181114063514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

  create_table "amenities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "builders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "production"
    t.text "website"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.text "about"
    t.text "locations"
  end

  create_table "builders_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "builder_id"
    t.index ["builder_id"], name: "index_builders_users_on_builder_id"
    t.index ["user_id"], name: "index_builders_users_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name", null: false
    t.text "information"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_collections_on_region_id"
  end

  create_table "communities", force: :cascade do |t|
    t.string "name", null: false
    t.text "location", null: false
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "yearly_hoa_fees"
    t.decimal "property_tax_rate"
    t.index ["division_id"], name: "index_communities_on_division_id"
  end

  create_table "communities_amenities", force: :cascade do |t|
    t.bigint "community_id"
    t.bigint "amenity_id"
    t.index ["amenity_id"], name: "index_communities_amenities_on_amenity_id"
    t.index ["community_id"], name: "index_communities_amenities_on_community_id"
  end

  create_table "communities_plans", force: :cascade do |t|
    t.bigint "community_id"
    t.bigint "plan_id"
    t.decimal "base_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_communities_plans_on_community_id"
    t.index ["plan_id"], name: "index_communities_plans_on_plan_id"
  end

  create_table "community_plan_options", force: :cascade do |t|
    t.bigint "community_id"
    t.bigint "plan_option_id"
    t.decimal "base_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_plan_options_on_community_id"
    t.index ["plan_option_id"], name: "index_community_plan_options_on_plan_option_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "phone"
    t.string "email", null: false
    t.string "title"
    t.boolean "builder_default", default: false, null: false
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.bigint "builder_id"
    t.index ["builder_id"], name: "index_contacts_on_builder_id"
    t.index ["division_id"], name: "index_contacts_on_division_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_divisions_on_region_id"
  end

  create_table "elevations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price", default: "0.0", null: false
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["plan_id"], name: "index_elevations_on_plan_id"
  end

  create_table "excluded_plan_options", force: :cascade do |t|
    t.integer "plan_option_id"
    t.integer "excluded_plan_option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_option_id"], name: "index_excluded_plan_options_on_plan_option_id"
  end

  create_table "lots", force: :cascade do |t|
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.text "information"
    t.decimal "price", default: "0.0", null: false
    t.integer "sqft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.text "location", null: false
    t.integer "length"
    t.integer "width"
    t.integer "setback_front"
    t.integer "setback_back"
    t.integer "setback_left"
    t.integer "setback_right"
    t.bigint "community_id"
    t.index ["community_id"], name: "index_lots_on_community_id"
  end

  create_table "plan_images", force: :cascade do |t|
    t.bigint "plan_id"
    t.decimal "story", null: false
    t.string "base_image_file_name", null: false
    t.string "base_image_content_type", null: false
    t.integer "base_image_file_size", null: false
    t.datetime "base_image_updated_at", null: false
    t.index ["plan_id"], name: "index_plan_images_on_plan_id"
  end

  create_table "plan_option_sets", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "default_plan_option_id"
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "position_2d_x"
    t.float "position_2d_y"
    t.decimal "story", default: "1.0", null: false
    t.index ["default_plan_option_id"], name: "index_plan_option_sets_on_default_plan_option_id"
    t.index ["plan_id"], name: "index_plan_option_sets_on_plan_id"
  end

  create_table "plan_options", force: :cascade do |t|
    t.string "name", null: false
    t.text "information"
    t.decimal "default_price", null: false
    t.text "category", null: false
    t.integer "sqft_ac"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "plan_image_file_name"
    t.string "plan_image_content_type"
    t.integer "plan_image_file_size"
    t.datetime "plan_image_updated_at"
    t.string "thumbnail_image_file_name"
    t.string "thumbnail_image_content_type"
    t.integer "thumbnail_image_file_size"
    t.datetime "thumbnail_image_updated_at"
    t.text "pano_image"
    t.text "vr_parameter"
    t.string "type", default: "uncategorized", null: false
    t.integer "sqft_living"
    t.integer "sqft_porch"
    t.integer "sqft_patio"
    t.integer "width"
    t.integer "depth"
    t.integer "plan_option_set_id"
  end

  create_table "plan_rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_styles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.text "information"
    t.decimal "min_price", precision: 12, scale: 2
    t.bigint "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "min_sqft", null: false
    t.decimal "min_bedrooms", null: false
    t.decimal "min_bathrooms", null: false
    t.decimal "min_garage", null: false
    t.decimal "min_stories", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.decimal "max_price", precision: 12, scale: 2
    t.integer "max_sqft"
    t.decimal "max_bedrooms"
    t.decimal "max_bathrooms"
    t.decimal "max_garage"
    t.decimal "max_stories"
    t.bigint "default_vr_scene_id"
    t.index ["collection_id"], name: "index_plans_on_collection_id"
  end

  create_table "plans_lots", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "lot_id"
    t.index ["lot_id"], name: "index_plans_lots_on_lot_id"
    t.index ["plan_id"], name: "index_plans_lots_on_plan_id"
  end

  create_table "plans_plan_styles", force: :cascade do |t|
    t.bigint "plan_id"
    t.bigint "plan_style_id"
    t.index ["plan_id"], name: "index_plans_plan_styles_on_plan_id"
    t.index ["plan_style_id"], name: "index_plans_plan_styles_on_plan_style_id"
  end

  create_table "raw_plan_files", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.string "object_file_name", null: false
    t.string "object_content_type", null: false
    t.integer "object_file_size", null: false
    t.datetime "object_updated_at", null: false
    t.index ["plan_id"], name: "index_raw_plan_files_on_plan_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "builder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["builder_id"], name: "index_regions_on_builder_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "saved_plan_options", force: :cascade do |t|
    t.decimal "quoted_price", precision: 12, scale: 2
    t.bigint "saved_plan_id", null: false
    t.bigint "plan_option_set_id", null: false
    t.bigint "plan_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_option_id"], name: "index_saved_plan_options_on_plan_option_id"
    t.index ["plan_option_set_id"], name: "index_saved_plan_options_on_plan_option_set_id"
    t.index ["saved_plan_id", "plan_option_set_id"], name: "saved_plan_and_plan_option_set", unique: true
    t.index ["saved_plan_id"], name: "index_saved_plan_options_on_saved_plan_id"
  end

  create_table "saved_plans", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "user_id", null: false
    t.bigint "elevation_id"
    t.bigint "contact_id"
    t.decimal "quoted_price", precision: 12, scale: 2
    t.datetime "ordered_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.index ["contact_id"], name: "index_saved_plans_on_contact_id"
    t.index ["elevation_id"], name: "index_saved_plans_on_elevation_id"
    t.index ["plan_id"], name: "index_saved_plans_on_plan_id"
    t.index ["user_id"], name: "index_saved_plans_on_user_id"
  end

  create_table "saved_searches", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "criteria", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "user_viewed_plans", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_user_viewed_plans_on_plan_id"
    t.index ["user_id"], name: "index_user_viewed_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "profile", default: "{}", null: false
    t.boolean "guest", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "vr_hotspots", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "vr_scene_id"
    t.bigint "plan_option_set_id"
    t.bigint "jump_scene_id"
    t.string "position"
    t.string "rotation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "toggle_default", null: false
    t.string "type", default: "menu", null: false
    t.string "toggle_method"
    t.bigint "show_on_plan_option_id"
    t.bigint "hide_on_plan_option_id"
    t.index ["jump_scene_id"], name: "index_vr_hotspots_on_jump_scene_id"
    t.index ["plan_option_set_id"], name: "index_vr_hotspots_on_plan_option_set_id"
    t.index ["vr_scene_id"], name: "index_vr_hotspots_on_vr_scene_id"
  end

  create_table "vr_scenes", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_vr_scenes_on_plan_id"
  end

  add_foreign_key "collections", "regions"
  add_foreign_key "communities", "divisions"
  add_foreign_key "communities_plans", "communities"
  add_foreign_key "communities_plans", "plans"
  add_foreign_key "community_plan_options", "communities"
  add_foreign_key "community_plan_options", "plan_options"
  add_foreign_key "contacts", "divisions"
  add_foreign_key "divisions", "regions"
  add_foreign_key "elevations", "plans"
  add_foreign_key "excluded_plan_options", "plan_options"
  add_foreign_key "excluded_plan_options", "plan_options", column: "excluded_plan_option_id"
  add_foreign_key "lots", "communities"
  add_foreign_key "plan_images", "plans"
  add_foreign_key "plan_option_sets", "plans"
  add_foreign_key "plans", "collections"
  add_foreign_key "raw_plan_files", "plans"
  add_foreign_key "regions", "builders"
  add_foreign_key "saved_plan_options", "plan_option_sets"
  add_foreign_key "saved_plan_options", "plan_options"
  add_foreign_key "saved_plan_options", "saved_plans"
  add_foreign_key "saved_plans", "contacts"
  add_foreign_key "saved_plans", "elevations"
  add_foreign_key "saved_plans", "plans"
  add_foreign_key "saved_plans", "users"
  add_foreign_key "saved_searches", "users"
  add_foreign_key "user_viewed_plans", "plans"
  add_foreign_key "user_viewed_plans", "users"
  add_foreign_key "vr_hotspots", "plan_option_sets"
  add_foreign_key "vr_hotspots", "vr_scenes"
  add_foreign_key "vr_scenes", "plans"
end
