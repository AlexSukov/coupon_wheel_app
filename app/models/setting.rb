class Setting < ApplicationRecord
  belongs_to :shop
  has_many :slices, dependent: :destroy
  mount_uploader :big_logo, BigImageUploader
  mount_uploader :small_logo, SmallImageUploader
  mount_uploader :tab_icon, TabIconUploader
  mount_uploader :facebook_image, FacebookUploader
  mount_uploader :facebook_image_mobile, FacebookUploader
end
