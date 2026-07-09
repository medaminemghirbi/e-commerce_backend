class Order < ApplicationRecord
  belongs_to :user, optional: true

  STATUSES = %w[pending confirmed shipped delivered cancelled].freeze
  validates :status, inclusion: { in: STATUSES }
  validates :user_email, presence: true

  scope :recent, -> { order(created_at: :desc) }

  after_update :deduct_stock_on_confirm, if: -> { saved_change_to_status? && status == 'confirmed' }
  after_update :restore_stock_on_cancel, if: -> { saved_change_to_status? && status == 'cancelled' && status_before_last_save == 'confirmed' }

  def short_id
    id.to_s.split("-").first.upcase
  end

  private

  def deduct_stock_on_confirm
    Array(items).each do |item|
      product = Product.find_by(id: item['productId'])
      next unless product
      new_qty = [ product.stock_quantity - item['quantity'].to_i, 0 ].max
      product.update_columns(stock_quantity: new_qty)
    end
  end

  def restore_stock_on_cancel
    Array(items).each do |item|
      product = Product.find_by(id: item['productId'])
      next unless product
      product.update_columns(stock_quantity: product.stock_quantity + item['quantity'].to_i)
    end
  end
end
