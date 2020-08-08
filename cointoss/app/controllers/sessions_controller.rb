class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create, :welcome, :about]

  def new
  end

  def greed
  end

  def bank
  end

  def create
      @user = User.find_by(username: params[:username])

      if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect_to '/welcome'
      else
          redirect_to '/login'
      end
  end

  def login
  end

  def welcome
      if current_user.present?
          redirect_to rooms_path
      end
  end

  def about
  end

  def page_requires_login
  end

  def logout
      session[:user_id] = nil
      redirect_to '/welcome'
  end
end
