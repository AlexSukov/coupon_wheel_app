class AddFacebookToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :facebook_enable, :boolean
    add_column :settings, :facebook_title, :string, default: 'YOU WON!'
    add_column :settings, :facebook_desc, :string, default: 'SHARE YOUR LUCK WITH FRIENDS TO GET ANOTHER SPIN'
    add_column :settings, :facebook_button, :string, default: 'SHARE ON FACEBOOK'
    add_column :settings, :facebook_text_color, :string, default: '#ffffff'
    add_column :settings, :facebook_button_text_color, :string, default: '#000000'
    add_column :settings, :facebook_button_color, :string, default: '#ffffff'
    add_column :settings, :facebook_image, :string
    add_column :settings, :facebook_image_mobile, :string
  end
end
