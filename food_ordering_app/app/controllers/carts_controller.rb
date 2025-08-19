class CartsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]

  def index
    @cart_items = current_user.cart_items.includes(:product)
    @cart_total = @cart_items.sum { |item| item.total_price }
  end

  def create
    product = Product.find(params[:product_id])
    quantity = (params[:quantity] || 1).to_i
    
    if quantity <= 0
      redirect_to root_path, alert: "Invalid quantity."
      return
    end
    
    existing_item = current_user.cart_items.find_by(product: product)
    
    if existing_item
      new_quantity = existing_item.quantity + quantity
      if existing_item.update(quantity: new_quantity)
        redirect_to carts_path, notice: "Item quantity updated in cart successfully."
      else
        redirect_to root_path, alert: "Failed to update cart item."
      end
    else
      @cart_item = current_user.cart_items.build(product: product, quantity: quantity)
      if @cart_item.save
        redirect_to carts_path, notice: "Item added to cart successfully."
      else
        redirect_to root_path, alert: "Failed to add item to cart."
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Product not found."
  end

  def destroy
    if @cart_item.destroy
      redirect_to carts_path, notice: "Item removed from cart successfully."
    else
      redirect_to carts_path, alert: "Failed to remove item from cart."
    end
  end

  def update
    new_quantity = params[:quantity].to_i
    
    if new_quantity < 0
      redirect_to carts_path, alert: "Invalid quantity."
      return
    end
    
    if new_quantity == 0
      if @cart_item.destroy
        redirect_to carts_path, notice: "Item removed from cart."
      else
        redirect_to carts_path, alert: "Failed to remove item from cart."
      end
    else
      if @cart_item.update(quantity: new_quantity)
        redirect_to carts_path, notice: "Cart updated successfully."
      else
        redirect_to carts_path, alert: "Failed to update cart: #{@cart_item.errors.full_messages.join(', ')}"
      end
    end
  end

  def clear
    current_user.cart_items.destroy_all
    redirect_to carts_path, notice: "Cart cleared successfully."
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to carts_path, alert: "Cart item not found."
  end
end
