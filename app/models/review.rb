class Review < ApplicationRecord
  belongs_to :user
  belongs_to :order

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :order_id, uniqueness: { message: 'already has a review' }
  validate  :order_must_be_eligible

  private

  def order_must_be_eligible
    return unless order
    unless %w[confirmed shipped delivered].include?(order.status)
      errors.add(:base, 'You can only review confirmed or delivered orders')
    end
    unless order.user_id == user_id
      errors.add(:base, 'This order does not belong to you')
    end
  end
end
