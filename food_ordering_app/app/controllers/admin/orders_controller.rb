class Admin::OrdersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_order, only: [:show]

  def index
    @orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
  end

  def show
  end

  private

  def set_order
    @order = Order.includes(:user, :order_items, :products).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_orders_path, alert: "Order not found."
  end
end 
