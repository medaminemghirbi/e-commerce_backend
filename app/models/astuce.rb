class Astuce < ApplicationRecord
  belongs_to :product, optional: true
  validates :title, presence: true
  scope :active, -> { where(active: true).order(:sort_order, :created_at) }
end
