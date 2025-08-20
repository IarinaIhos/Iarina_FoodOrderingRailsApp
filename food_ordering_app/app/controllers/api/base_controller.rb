class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  
  # Configure API to respond to JSON format
  respond_to :json
  
  # Set content type to JSON
  before_action :set_json_format
  
  # Handle API errors
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from StandardError, with: :internal_server_error

  def require_admin
    unless current_api_user&.admin?
      render json: { error: "You must be an admin to access this resource" }, status: :forbidden
    end
  end

  private

  def current_api_user
    return nil unless doorkeeper_token
    @current_api_user ||= User.find(doorkeeper_token.resource_owner_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end
  
  def set_json_format
    request.format = :json
  end
  
  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
  
  def internal_server_error(exception)
    render json: { error: "Internal server error" }, status: :internal_server_error
  end
end
