class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: true
  validates :category, presence: true
  validates :diet, presence: true

  enum :category, %w[appetizer main_course dessert beverage], default: "main_course"
  enum :diet, %w[regular vegetarian vegan gluten_free], default: "regular"

  scope :filter_by_category, -> (category) { where(category: category) if category != 'all' }
  scope :filter_by_diet, -> (diet) { where(diet: diet) if diet != 'all' }
  scope :sort_by_price, -> (sorting) {
    case sorting
    when 'asc'
      order(price: :asc)
    when 'desc'
      order(price: :desc)
    else
      all
    end
  }
end
