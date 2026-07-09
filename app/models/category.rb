class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :products, dependent: :nullify
  validates :name_fr, presence: true

  def name(locale = I18n.locale)
    send(:"name_#{locale}").presence || name_fr
  end
end
