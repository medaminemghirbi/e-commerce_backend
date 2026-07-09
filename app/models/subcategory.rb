class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :product_subcategories, dependent: :destroy
  has_many :products, through: :product_subcategories
  validates :name_fr, presence: true

  def name(locale = I18n.locale)
    send(:"name_#{locale}").presence || name_fr
  end
end
