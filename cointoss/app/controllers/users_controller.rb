class UsersController < ApplicationController

  skip_before_action :authorized, only: [:new, :create]

  def new
      @user = User.new
  end

  def create
      @user = User.create(params.require(:user)
                  .merge!(account_balance: 10000,
                          birth_time: Time.now)
                  .permit(:username,
                          :password,
                          :account_balance,
                          :birth_time))

      session[:user_id] = @user.id
      redirect_to '/welcome'
  end

  def logout
      @user = nil
      redirect_to '/welcome'
  end
end
