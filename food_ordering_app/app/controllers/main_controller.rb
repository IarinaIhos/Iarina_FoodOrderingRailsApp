class MainController < ApplicationController
  skip_before_action :require_login
  def index
    @hero = Hero.first
    @products = Product.all
    @products = @products.by_category(params[:category]) if params[:category].present? && params[:category] != "all"
    @products = @products.by_diet(params[:diet]) if params[:diet].present? && params[:diet] != "all"
    @products = @products.sorted_by(params[:sorting]) if params[:sorting].present? && params[:sorting] != "none"
    
    if params[:min_price].present? && params[:max_price].present?
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      @products = @products.price_range(min_price, max_price)
    end
  end
end
