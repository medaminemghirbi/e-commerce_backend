class ContactRequest < ApplicationRecord
  belongs_to :product, optional: true
  validates :first_name, :last_name, :email, :message, presence: true
  STATUSES = %w[new read replied].freeze

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'new'
  end
end
