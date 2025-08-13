class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :name, presence: true

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  has_many :orders, dependent: :destroy

  enum :role, { user: 0, admin: 1 }
end
