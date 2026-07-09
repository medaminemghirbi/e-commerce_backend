class Coupon < ApplicationRecord
  TYPES = %w[percentage fixed].freeze

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, inclusion: { in: TYPES }
  validates :discount_value, numericality: { greater_than: 0 }
  validates :discount_value, numericality: { less_than_or_equal_to: 100 }, if: -> { discount_type == 'percentage' }

  before_save { self.code = code.upcase.strip }

  def valid_for?(order_total)
    return false unless active?
    return false if expires_at.present? && expires_at < Time.current
    return false if max_uses.present? && used_count >= max_uses
    return false if order_total < min_order_amount.to_f
    true
  end

  def apply(order_total)
    if discount_type == 'percentage'
      (order_total * discount_value / 100.0).round(2)
    else
      [discount_value, order_total].min.round(2)
    end
  end

  def increment_usage!
    increment!(:used_count)
  end
end
