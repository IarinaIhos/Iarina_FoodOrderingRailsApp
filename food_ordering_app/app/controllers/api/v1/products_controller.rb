class Api::V1::ProductsController < Api::BaseController
  skip_before_action :authenticate_user!

  def index
    products = Product.all
    products = apply_filters(products)
    render json: products
  end

  def show
    product = Product.find(params[:id])
    render json: product
  end

  private

  def apply_filters(products)
    products = products.where(category: params[:category]) if params[:category].present?
    products = products.where(price: params[:price]) if params[:price].present?
    products = products.where(brand: params[:brand]) if params[:brand].present?

    if params[:min_price].present? && params[:max_price].present?
        min_price = params[:min_price].to_f
        max_price = params[:max_price].to_f
        products = products.price_range(min_price, max_price)
    end
    products
  end
end
