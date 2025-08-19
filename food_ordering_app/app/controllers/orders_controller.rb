class OrdersController < ApplicationController
  before_action :require_login
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
  end

  def show
    unless @order.user == current_user || current_user.admin?
      redirect_to orders_path, alert: "Access denied."
    end
  end

  def create
    cart_items = current_user.cart_items.includes(:product)
    
    if cart_items.empty?
      redirect_to carts_path, alert: "Your cart is empty."
      return
    end

    begin
      order = Order.create_from_cart(current_user, cart_items)
      
      if order
        redirect_to order_path(order), notice: "Order placed successfully! Your order number is ##{order.id}."
      else
        redirect_to carts_path, alert: "Failed to create order."
      end
    rescue => e
      redirect_to carts_path, alert: "Error creating order: #{e.message}"
    end
  end

  private

  def set_order
    @order = Order.includes(:order_items, :products).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Order not found."
  end
end 