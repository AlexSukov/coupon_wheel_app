class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.belongs_to :shop, foreign_key: true
      t.boolean :enable
      t.string :big_logo
      t.string :small_logo
      t.string :title_text
      t.text :disclaimer_text
      t.text :guiding_text
      t.string :enter_email
      t.string :invalid_email_message
      t.string :spin_button
      t.string :close_button
      t.string :winning_title
      t.string :winning_text
      t.string :discount_code_title
      t.string :continue_button
      t.string :copied_message
      t.string :rejest_discount_button
      t.string :free_product_description
      t.string :free_product_button
      t.string :free_product_reject
      t.string :discount_coupon_code_bar
      t.string :close_button_in_bar

      t.string :theme
      t.string :background_color
      t.string :font_color
      t.string :bold_text_and_button_color
      t.string :win_section_color
      t.string :lose_section_color

      t.boolean :enable_discount_code_bar
      t.string :discount_code_bar_countdown_time
      t.string :discount_code_bar_position

      t.boolean :enable_progress_bar
      t.string :progress_bar_text
      t.string :progress_bar_color
      t.string :progress_bar_percentage
      t.string :progress_bar_position

      t.boolean :show_on_desktop
      t.boolean :show_on_mobile
      t.boolean :show_on_desktop_leave_intent
      t.boolean :show_on_mobile_leave_intent
      t.boolean :show_on_desktop_after
      t.boolean :show_on_mobile_after
      t.string :show_on_desktop_seconds
      t.string :show_on_mobile_seconds

      t.boolean :show_pull_out_tab
      t.string :tab_icon

      t.string :do_not_show_app

      t.boolean :discount_coupon_auto_apply

      t.timestamps
    end
  end
end
