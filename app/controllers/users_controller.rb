class UsersController < ApplicationController
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user   # same as user_path(@user)  (which RSpec needs to use since it doesn't understand simply @user)
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end
  
end
