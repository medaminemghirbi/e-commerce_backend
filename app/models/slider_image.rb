class SliderImage < ApplicationRecord
  validates :image_url, presence: true
  scope :active,  -> { where(active: true).order(:sort_order) }
  scope :ordered, -> { order(:sort_order) }
end
