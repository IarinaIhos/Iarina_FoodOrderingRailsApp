class Api::V1::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, except: [:create] # Skip auth for create
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

  def create
    Rails.logger.info "Creating user with params: #{user_params.inspect}"
    
    # Check if user already exists
    existing_user = User.find_by(email: user_params[:email])
    if existing_user
      render json: {
        status: 'error',
        message: 'User already exists',
        errors: ['Email is already taken']
      }, status: :unprocessable_entity
      return
    end
    
    user = User.new(user_params)
    user.uid = user.email # Set uid for Devise Token Auth compatibility
    user.provider = 'email' # Set provider for Devise Token Auth compatibility
    
    if user.save
      Rails.logger.info "User created successfully: #{user.id}"
      render json: {
        status: 'success',
        message: 'User created successfully',
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
      }, status: :created
    else
      Rails.logger.error "User creation failed: #{user.errors.full_messages}"
      render json: {
        status: 'error',
        message: 'Failed to create user',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error "Duplicate user error: #{e.message}"
    render json: {
      status: 'error',
      message: 'User already exists',
      errors: ['Email is already taken']
    }, status: :unprocessable_entity
  rescue => e
    Rails.logger.error "Exception in create: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: {
      status: 'error',
      message: 'Internal server error',
      errors: [e.message]
    }, status: :internal_server_error
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
