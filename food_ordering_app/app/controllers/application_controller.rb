class ApplicationController < ActionController::Base
  before_action :require_login
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to root_path, alert: "You must be logged in to access this page"
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You must be an admin to access this page"  
    end
  end 
end
