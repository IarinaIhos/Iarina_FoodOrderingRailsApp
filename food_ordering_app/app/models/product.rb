class Product < ApplicationRecord
  has_one_attached :image
  has_many :cart_items, dependent: :destroy
  has_many :users, through: :cart_items
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :diet, presence: true

  enum :category, { appetizer: 0, main_course: 1, dessert: 2, beverage: 3 }
  enum :diet, { regular: 0, vegetarian: 1, vegan: 2, gluten_free: 3 }

  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_diet, ->(diet) { where(diet: diet) if diet.present? }
  scope :price_range, ->(min_price, max_price) { where(price: min_price..max_price) if min_price.present? && max_price.present? }
  scope :sorted_by, ->(sort_option) {
    case sort_option
    when 'price_asc'
      order(price: :asc)
    when 'price_desc'
      order(price: :desc)
    when 'name_asc'
      order(name: :asc)
    when 'name_desc'
      order(name: :desc)
    else
      order(created_at: :desc)
    end
  }
end
