class MainController < ApplicationController
  def index
    @hero = Hero.first
    @products = Product.all
    @products = @products.filter_by_category(params[:category]) if params[:category].present? && params[:category] != "all"
    @products = @products.filter_by_diet(params[:diet]) if params[:diet].present? && params[:diet] != "all"
    @products = @products.sort_by_price(params[:sorting]) if params[:sorting].present? && params[:sorting] != "none"

    puts "Filtered products count: #{@products.count}"
  end
end