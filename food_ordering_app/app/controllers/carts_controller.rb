class CartsController < ApplicationController
  before_action :require_login

  def index
    @cart_items = current_user.cart_items.includes(:product)
  end

  def create
    product = Product.find(params[:product_id])
    current_user.cart_items.create(product: product, quantity: params[:quantity] || 1)

    redirect_to carts_path, notice: "Item added to cart successfully."
  end

  def destroy
    item = CartItem.find(params[:id])
    item.destroy

    redirect_to carts_path, notice: "Item removed from cart successfully."
  end

  def update
  puts "Params: #{params.inspect}" 
  item = CartItem.find(params[:id])

  item.update(quantity: params[:quantity].to_i)
    
  redirect_to carts_path, notice: "Cart updated successfully."
  end
end
