class Api::V1::Admin::OrdersController < Api::BaseController
    before_action :doorkeeper_authorize! 
    before_action :admin_required 
    before_action :set_order, only: [:show, :update, :destroy]
  
    def index
      orders = Order.includes(:user, :order_items, :products).order(created_at: :desc)
      
      render json: {
        status: 'success',
        message: 'Orders retrieved successfully',
        data: {
          orders: orders.map do |order|
            {
              id: order.id,
              user: {
                id: order.user.id,
                name: order.user.name,
                email: order.user.email
              },
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
      render json: {
        status: 'success',
        message: 'Order retrieved successfully',
        data: {
          order: {
            id: @order.id,
            user: {
              id: @order.user.id,
              name: @order.user.name,
              email: @order.user.email
            },
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
  
    def update
      if @order.update(order_params)
        render json: {
          status: 'success',
          message: 'Order updated successfully',
          data: {
            order: {
              id: @order.id,
              user: {
                id: @order.user.id,
                name: @order.user.name,
                email: @order.user.email
              },
              total_amount: @order.total_amount,
              status: @order.status || 'pending',
              created_at: @order.created_at,
              updated_at: @order.updated_at
            }
          }
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to update order',
          errors: @order.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    def destroy
      if @order.destroy
        render json: {
          status: 'success',
          message: 'Order deleted successfully'
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to delete order',
          errors: @order.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_order
      @order = Order.includes(:user, :order_items, :products).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'Order not found'
      }, status: :not_found
    end
  
    def order_params
      params.require(:order).permit(:status, :total_amount)
    end
  end
