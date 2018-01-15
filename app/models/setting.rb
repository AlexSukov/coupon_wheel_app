class Setting < ApplicationRecord
  belongs_to :shop
  has_many :slices, inverse_of: :setting
  accepts_nested_attributes_for :slices, reject_if: :all_blank, allow_destroy: true
end
