class Api::BaseController < ActionController::API
    before_action :doorkeeper_authorize!
    before_action :set_current_user
  
    # Handle common errors
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from StandardError, with: :internal_server_error
  
    protected
  
    def doorkeeper_unauthorized_render_options(error: nil)
      {
        json: {
          code: error&.state || 'unauthorized',
          message: 'Authentication required',
          expired: error&.reason == :expired,
          errors: ['Invalid or expired access token']
        },
        status: :unauthorized
      }
    end
  
    def render_error_message(message = nil, status: :unprocessable_entity)
      render json: {
        message: 'Error',
        errors: Array.wrap(message),
        code: status.to_s
      }, status: status
    end
  
    def render_success(data = {}, message: 'Success', status: :ok)
      render json: {
        message: message,
        data: data,
        code: status.to_s
      }, status: status
    end
  
    def set_current_user
      return unless doorkeeper_token
      @current_user = User.find(doorkeeper_token[:resource_owner_id])
    rescue ActiveRecord::RecordNotFound
      @current_user = nil
    end
  
    def current_user
      @current_user
    end
  
    def admin_required
      render_error_message('Admin access required', status: :forbidden) unless current_user&.admin?
    end
  
    private
  
    def not_found(exception)
      render json: {
        message: 'Error',
        errors: [exception.message],
        code: 'not_found'
      }, status: :not_found
    end
  
    def internal_server_error(exception)
      render json: {
        message: 'Error',
        errors: ['Internal server error'],
        code: 'internal_server_error'
      }, status: :internal_server_error
    end
  end
