class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.belongs_to :shop, foreign_key: true
      t.boolean :enable, default: false
      t.string :big_logo
      t.string :small_logo
      t.string :title_text, default: "Shop <b>special bonus</b> unlocked"
      t.text :disclaimer_text, default: "You have a chance to win a nice big fat discount. Are you ready?"
      t.text :guiding_text, default: "* You can spin the wheel only once.<br>* If you win, you can claim your coupon for 10 mins only!"
      t.string :enter_email, default: "Enter your email address"
      t.string :invalid_email_message, default: "Please enter a valid email"
      t.string :spin_button, default: "Try your luck"
      t.string :close_button, default: "No, I don't feel lucky"
      t.string :winning_title, default: "Hurrah! You've hit. Lucky day!"
      t.string :winning_text, default: "Don't forget to use the discount code at checkout!"
      t.string :discount_code_title, default: "Your discount code is:"
      t.string :continue_button, default: "Continue & use discount"
      t.string :copied_message, default: "Copied to clipboard!"
      t.string :reject_discount_button, default: "Reject discount code"
      t.string :free_product_description, default: "You have won this nice product! Press button below to get it."
      t.string :free_product_button, default: "Take it"
      t.string :free_product_reject, default: "Reject free product"
      t.string :discount_coupon_code_bar, default: "Your coupon code is reserved for"
      t.string :close_button_in_bar, default: "close"

      t.string :theme, default: "Default"
      t.string :background_color, default: "#000000"
      t.string :font_color, default: "#ffffff"
      t.string :bold_text_and_button_color, default: "#fff000"
      t.string :win_section_color, default: "#000fff"
      t.string :lose_section_color, default: "#00ff00"

      t.boolean :enable_discount_code_bar, default: false
      t.integer :discount_code_bar_countdown_time, default: 15
      t.string :discount_code_bar_position, default: "Screen bottom"

      t.boolean :enable_progress_bar, default: false
      t.string :progress_bar_text, default: "70% offers claimed. Hurry up!"
      t.string :progress_bar_color, default: "#ff00ff"
      t.integer :progress_bar_percentage, default: 70
      t.string :progress_bar_position, default: "Under top title"

      t.boolean :show_on_desktop, default: true
      t.boolean :show_on_mobile, default: true
      t.boolean :show_on_desktop_leave_intent, default: true
      t.boolean :show_on_mobile_leave_intent, default: true
      t.boolean :show_on_desktop_after, default: false
      t.boolean :show_on_mobile_after, default: false
      t.integer :show_on_desktop_seconds, default: 15
      t.integer :show_on_mobile_seconds, default: 15

      t.boolean :show_pull_out_tab, default: false
      t.string :tab_icon, default: 'None'

      t.integer :do_not_show_app, default: 30

      t.boolean :discount_coupon_auto_apply, default: false

      t.timestamps
    end
  end
end
