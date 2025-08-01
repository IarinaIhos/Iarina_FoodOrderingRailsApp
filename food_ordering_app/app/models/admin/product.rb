class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: true
  validates :category, presence: true
  validates :diet, presence: true

  enum :category, %w[appetizer main_course dessert beverage], default: "main_course"
  enum :diet, %w[regular vegetarian vegan gluten_free], default: "regular"
end
