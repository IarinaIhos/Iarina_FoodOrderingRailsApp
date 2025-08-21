class Api::V1::Admin::ProductsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :admin_required 
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all.order(:created_at)
    
    render json: {
      status: 'success',
      message: 'Products retrieved successfully',
      data: {
        products: products.map do |product|
          {
            id: product.id,
            name: product.name,
            category: product.category,
            diet: product.diet,
            price: product.price,
            description: product.description,
            image_url: nil,
            created_at: product.created_at,
            updated_at: product.updated_at
          }
        end,
        total_count: products.count
      }
    }
  end

  def show
    render json: {
      status: 'success',
      message: 'Product retrieved successfully',
      data: {
        product: {
          id: @product.id,
          name: @product.name,
          category: @product.category,
          diet: @product.diet,
          price: @product.price,
          description: @product.description,
          image_url: nil,
          created_at: @product.created_at,
          updated_at: @product.updated_at
        }
      }
    }
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      render json: {
        status: 'success',
        message: 'Product created successfully',
        data: {
          product: {
            id: @product.id,
            name: @product.name,
            category: @product.category,
            diet: @product.diet,
            price: @product.price,
            description: @product.description,
            image_url: @product.image.attached? ? rails_blob_url(@product.image) : nil,
            created_at: @product.created_at,
            updated_at: @product.updated_at
          }
        }
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Failed to create product',
        errors: @product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: {
        status: 'success',
        message: 'Product updated successfully',
        data: {
          product: {
            id: @product.id,
            name: @product.name,
            category: @product.category,
            diet: @product.diet,
            price: @product.price,
            description: @product.description,
            image_url: @product.image.attached? ? rails_blob_url(@product.image) : nil,
            created_at: @product.created_at,
            updated_at: @product.updated_at
          }
        }
      }
    else
      render json: {
        status: 'error',
        message: 'Failed to update product',
        errors: @product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {
        status: 'success',
        message: 'Product deleted successfully'
      }
    else
      render json: {
        status: 'error',
        message: 'Failed to delete product',
        errors: @product.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 'error',
      message: 'Product not found'
    }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :category, :diet, :price, :description, :image)
  end
end
