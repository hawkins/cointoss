class UsersController < ApplicationController

    skip_before_action :authorized, only: [:new, :create]

  def new
      @user = User.new
  end

  def create
      @user = User.create(params.require(:user).permit(:username,:password))
      session[:user_id] = @user.id
      redirect_to '/welcome'
  end

  def logout
      @user = nil
      redirect_to '/welcome'
  end
end
