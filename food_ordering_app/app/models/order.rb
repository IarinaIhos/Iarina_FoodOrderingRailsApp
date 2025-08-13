class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  def self.create_from_cart(user, cart_items)
    return nil if cart_items.empty?

    total_amount = cart_items.sum { |item| item.product.price * item.quantity }
    
    order = user.orders.create!(
      total_amount: total_amount + 5.00
    )

    cart_items.each do |cart_item|
      order.order_items.create!(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end
    
    user.cart_items.destroy_all

    order
  end
end 