class Api::V1::OrdersController < Api::BaseController
    before_action :doorkeeper_authorize! 
    before_action :prevent_admin_access 
    before_action :set_order, only: [:show]
  
    def index
      orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc)
      
      render json: {
        status: 'success',
        message: 'Orders retrieved successfully',
        data: {
          orders: orders.map do |order|
            {
              id: order.id,
              total_amount: order.total_amount,
              status: order.status || 'pending',
              created_at: order.created_at,
              updated_at: order.updated_at,
              order_items_count: order.order_items.count
            }
          end,
          total_count: orders.count
        }
      }
    end
  
    def show
      unless @order.user == current_user
        render json: {
          status: 'error',
          message: 'Access denied'
        }, status: :forbidden
        return
      end
  
      render json: {
        status: 'success',
        message: 'Order retrieved successfully',
        data: {
          order: {
            id: @order.id,
            total_amount: @order.total_amount,
            status: @order.status || 'pending',
            created_at: @order.created_at,
            updated_at: @order.updated_at,
            order_items: @order.order_items.map do |item|
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
                price: item.price,
                total_price: item.total_price
              }
            end
          }
        }
      }
    end
  
    def create
      cart_items = current_user.cart_items.includes(:product)
      
      if cart_items.empty?
        render json: {
          status: 'error',
          message: 'Your cart is empty'
        }, status: :unprocessable_entity
        return
      end
  
      begin
        order = Order.create_from_cart(current_user, cart_items)
        
        if order
          render json: {
            status: 'success',
            message: "Order placed successfully! Your order number is ##{order.id}.",
            data: {
              order: {
                id: order.id,
                total_amount: order.total_amount,
                status: order.status || 'pending',
                created_at: order.created_at,
                updated_at: order.updated_at,
                order_items: order.order_items.map do |item|
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
                    price: item.price,
                    total_price: item.total_price
                  }
                end
              }
            }
          }, status: :created
        else
          render json: {
            status: 'error',
            message: 'Failed to create order'
          }, status: :unprocessable_entity
        end
      rescue => e
        render json: {
          status: 'error',
          message: 'Failed to create order',
          errors: [e.message]
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def prevent_admin_access
      if current_user&.admin?
        render json: {
          status: 'error',
          message: 'Admins cannot access user order functionality'
        }, status: :forbidden
      end
    end
  
    def set_order
      @order = Order.includes(:order_items, :products).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'Order not found'
      }, status: :not_found
    end
  end
