class Faq < ApplicationRecord
  validates :question, :answer, presence: true

  scope :active, -> { where(active: true).order(:sort_order, :created_at) }
end
