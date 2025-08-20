class Api::V1::UsersController < Api::BaseController
  before_action :doorkeeper_authorize! # Ensure the user is authenticated via Doorkeeper
  before_action :require_admin, only: [:index, :show] # Ensure only admins can access these actions
  def index
    users = User.all
    
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
end
