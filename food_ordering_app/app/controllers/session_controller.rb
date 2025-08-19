class SessionController < ApplicationController
  skip_before_action :require_login

  def index
    redirect_to root_path if logged_in?
  end
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email].downcase)

    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Auth successful"
    else
      flash.now[:alert] = user ? "Invalid email or password" : "User does not exist"
      render :new, status: :unprocessable_entity
    end
  end

  def success
    redirect_to root_path unless session[:user_id]
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Logged out successfully"
  end
end
