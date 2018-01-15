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

ActiveRecord::Schema.define(version: 20180115145624) do

  create_table "collected_emails", force: :cascade do |t|
    t.string "email"
    t.integer "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_collected_emails_on_shop_id"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "shop_id"
    t.boolean "enable"
    t.string "big_logo"
    t.string "small_logo"
    t.string "title_text"
    t.text "disclaimer_text"
    t.text "guiding_text"
    t.string "enter_email"
    t.string "invalid_email_message"
    t.string "spin_button"
    t.string "close_button"
    t.string "winning_title"
    t.string "winning_text"
    t.string "discount_code_title"
    t.string "continue_button"
    t.string "copied_message"
    t.string "reject_discount_button"
    t.string "free_product_description"
    t.string "free_product_button"
    t.string "free_product_reject"
    t.string "discount_coupon_code_bar"
    t.string "close_button_in_bar"
    t.string "theme"
    t.string "background_color"
    t.string "font_color"
    t.string "bold_text_and_button_color"
    t.string "win_section_color"
    t.string "lose_section_color"
    t.boolean "enable_discount_code_bar"
    t.string "discount_code_bar_countdown_time"
    t.string "discount_code_bar_position"
    t.boolean "enable_progress_bar"
    t.string "progress_bar_text"
    t.string "progress_bar_color"
    t.string "progress_bar_percentage"
    t.string "progress_bar_position"
    t.boolean "show_on_desktop"
    t.boolean "show_on_mobile"
    t.boolean "show_on_desktop_leave_intent"
    t.boolean "show_on_mobile_leave_intent"
    t.boolean "show_on_desktop_after"
    t.boolean "show_on_mobile_after"
    t.string "show_on_desktop_seconds"
    t.string "show_on_mobile_seconds"
    t.boolean "show_pull_out_tab"
    t.string "tab_icon"
    t.string "do_not_show_app"
    t.boolean "discount_coupon_auto_apply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_settings_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "slices", force: :cascade do |t|
    t.boolean "lose"
    t.string "type"
    t.string "label"
    t.string "code"
    t.integer "gravity"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_slices_on_setting_id"
  end

end
