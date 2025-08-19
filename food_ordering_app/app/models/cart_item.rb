class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :product_id, presence: true

  def total_price
    product.price * quantity
  end

  def increase_quantity(amount = 1)
    update(quantity: quantity + amount)
  end

  def decrease_quantity(amount = 1)
    new_quantity = quantity - amount
    if new_quantity <= 0
      destroy
    else
      update(quantity: new_quantity)
    end
  end

  def self.total_items_for_user(user)
    where(user: user).sum(:quantity)
  end

  def self.total_price_for_user(user)
    joins(:product).where(user: user).sum('products.price * cart_items.quantity')
  end
end
