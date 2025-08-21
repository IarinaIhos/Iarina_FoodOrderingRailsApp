class Api::V1::CartsController < Api::BaseController
    before_action :doorkeeper_authorize! 
    before_action :prevent_admin_access
    before_action :set_cart_item, only: [:update, :destroy]
  
    def index
      cart_items = current_user.cart_items.includes(:product)
      cart_total = cart_items.sum { |item| item.total_price }
      
      render json: {
        status: 'success',
        message: 'Cart retrieved successfully',
        data: {
          cart_items: cart_items.map do |item|
            {
              id: item.id,
              product: {
                id: item.product.id,
                name: item.product.name,
                category: item.product.category,
                diet: item.product.diet,
                price: item.product.price,
                description: item.product.description,
                image_url: nil
              },
              quantity: item.quantity,
              total_price: item.total_price,
              created_at: item.created_at,
              updated_at: item.updated_at
            }
          end,
          cart_total: cart_total,
          total_items: cart_items.sum(:quantity)
        }
      }
    end
  
    def create
      product = Product.find(params[:product_id])
      quantity = (params[:quantity] || 1).to_i
      
      if quantity <= 0
        render json: {
          status: 'error',
          message: 'Invalid quantity'
        }, status: :unprocessable_entity
        return
      end
      
      existing_item = current_user.cart_items.find_by(product: product)
      
      if existing_item
        new_quantity = existing_item.quantity + quantity
        if existing_item.update(quantity: new_quantity)
          render json: {
            status: 'success',
            message: 'Item quantity updated in cart successfully',
            data: {
              cart_item: {
                id: existing_item.id,
                product: {
                  id: existing_item.product.id,
                  name: existing_item.product.name,
                  category: existing_item.product.category,
                  diet: existing_item.product.diet,
                  price: existing_item.product.price,
                  description: existing_item.product.description,
                  image_url: nil
                },
                quantity: existing_item.quantity,
                total_price: existing_item.total_price
              }
            }
          }
        else
          render json: {
            status: 'error',
            message: 'Failed to update cart item',
            errors: existing_item.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        cart_item = current_user.cart_items.build(product: product, quantity: quantity)
        if cart_item.save
          render json: {
            status: 'success',
            message: 'Item added to cart successfully',
            data: {
              cart_item: {
                id: cart_item.id,
                product: {
                  id: cart_item.product.id,
                  name: cart_item.product.name,
                  category: cart_item.product.category,
                  diet: cart_item.product.diet,
                  price: cart_item.product.price,
                  description: cart_item.product.description,
                  image_url: nil
                },
                quantity: cart_item.quantity,
                total_price: cart_item.total_price
              }
            }
          }, status: :created
        else
          render json: {
            status: 'error',
            message: 'Failed to add item to cart',
            errors: cart_item.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'Product not found'
      }, status: :not_found
    end
  
    def update
      new_quantity = params[:quantity].to_i
      
      if new_quantity < 0
        render json: {
          status: 'error',
          message: 'Invalid quantity'
        }, status: :unprocessable_entity
        return
      end
      
      if new_quantity == 0
        if @cart_item.destroy
          render json: {
            status: 'success',
            message: 'Item removed from cart'
          }
        else
          render json: {
            status: 'error',
            message: 'Failed to remove item from cart',
            errors: @cart_item.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        if @cart_item.update(quantity: new_quantity)
          render json: {
            status: 'success',
            message: 'Cart updated successfully',
            data: {
              cart_item: {
                id: @cart_item.id,
                product: {
                  id: @cart_item.product.id,
                  name: @cart_item.product.name,
                  category: @cart_item.product.category,
                  diet: @cart_item.product.diet,
                  price: @cart_item.product.price,
                  description: @cart_item.product.description,
                  image_url: nil
                },
                quantity: @cart_item.quantity,
                total_price: @cart_item.total_price
              }
            }
          }
        else
          render json: {
            status: 'error',
            message: 'Failed to update cart',
            errors: @cart_item.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  
    def destroy
      if @cart_item.destroy
        render json: {
          status: 'success',
          message: 'Item removed from cart successfully'
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to remove item from cart',
          errors: @cart_item.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
    
    def clear
      current_user.cart_items.destroy_all
      render json: {
        status: 'success',
        message: 'Cart cleared successfully'
      }
    end
  
    private

    def prevent_admin_access
      if current_user&.admin?
        render json: {
          status: 'error',
          message: 'Admins cannot access cart functionality'
        }, status: :forbidden
      end
    end
  
    def set_cart_item
      @cart_item = current_user.cart_items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'Cart item not found'
      }, status: :not_found
    end
 end
