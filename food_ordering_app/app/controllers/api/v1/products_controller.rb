class Api::V1::ProductsController < Api::BaseController

  def index
    products = Product.all
    products = apply_filters(products)
    
    render json: {
      status: 'success',
      data: products.map { |product| product_json(product) }
    }
  end

  def show
    product = Product.find(params[:id])
    render json: {
      status: 'success',
      data: product_json(product)
    }
  end

  private

  def product_json(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      category: product.category,
      diet: product.diet,
      image_url: product.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(product.image) : nil,
      created_at: product.created_at,
      updated_at: product.updated_at
    }
  end

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
