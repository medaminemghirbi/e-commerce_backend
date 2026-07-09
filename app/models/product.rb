class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :marque, optional: true
  has_many :product_subcategories, dependent: :destroy
  has_many :subcategories, through: :product_subcategories
  has_many :contact_requests, dependent: :nullify

  validates :name_fr, presence: true
  validates :status, inclusion: { in: %w[active inactive] }

  scope :active, -> { where(status: "active") }
  scope :with_promotion, -> { where(has_promotion: true) }

  def name(locale = I18n.locale)
    send(:"name_#{locale}").presence || name_fr
  end

  def description(locale = I18n.locale)
    send(:"description_#{locale}").presence || description_fr
  end

  def current_price
    has_promotion? ? (price * (1 - promotion_discount / 100.0)).round(2) : price
  end

  def primary_image
    images&.first
  end
end
