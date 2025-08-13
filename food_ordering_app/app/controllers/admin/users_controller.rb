class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order(:created_at)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully."
    else
      redirect_to admin_users_path, alert: "Failed to delete user."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Access denied. Admin privileges required."
    end
  end
end 