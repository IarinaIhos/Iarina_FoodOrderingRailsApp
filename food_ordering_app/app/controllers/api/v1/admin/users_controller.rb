class Api::V1::Admin::UsersController < Api::BaseController
    before_action :doorkeeper_authorize! # Ensure the user is authenticated via Doorkeeper
    before_action :admin_required # Ensure only admins can access these actions
  
    def index
      users = User.all.order(:created_at)
      
      render json: {
        status: 'success',
        message: 'Users retrieved successfully',
        data: {
          users: users.map do |user|
            {
              id: user.id,
              email: user.email,
              name: user.name,
              role: user.role,
              created_at: user.created_at,
              updated_at: user.updated_at
            }
          end,
          total_count: users.count
        }
      }
    end
  
    def show
      user = User.find(params[:id])
      
      render json: {
        status: 'success',
        message: 'User retrieved successfully',
        data: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            created_at: user.created_at,
            updated_at: user.updated_at
          }
        }
      }
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'User not found'
      }, status: :not_found
    end
  
    def update
      user = User.find(params[:id])
      
      if user.update(user_params)
        render json: {
          status: 'success',
          message: 'User updated successfully',
          data: {
            user: {
              id: user.id,
              email: user.email,
              name: user.name,
              role: user.role,
              created_at: user.created_at,
              updated_at: user.updated_at
            }
          }
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to update user',
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'User not found'
      }, status: :not_found
    end
  
    def destroy
      user = User.find(params[:id])
      
      if user.destroy
        render json: {
          status: 'success',
          message: 'User deleted successfully'
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to delete user',
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: 'error',
        message: 'User not found'
      }, status: :not_found
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :role)
    end
  end
