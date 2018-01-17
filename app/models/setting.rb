class Setting < ApplicationRecord
  belongs_to :shop
  has_many :slices, dependent: :destroy
end
