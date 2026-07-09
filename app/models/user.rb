class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :nullify

  ROLES = %w[admin client].freeze
  validates :role, inclusion: { in: ROLES }
  before_validation :set_default_role

  def admin?
    role == "admin"
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def set_default_role
    self.role ||= "client"
  end
end
