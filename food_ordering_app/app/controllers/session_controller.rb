class SessionController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email].downcase)
    if user

      if user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: "auth successful"
      else
        flash.now[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    else
        flash.now[:alert] = "User does not exist"
        render :new, status: :unprocessable_entity
    end
  end
  def success
    redirect_to root_path unless session[:user_id]
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_path, notice: "Logged out successfully"
  end
end
