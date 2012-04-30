class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page]) # User.all
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    if current_user.nil?
      redirect_to(signin_path) 
      return
    else 
      unless current_user.admin?
        redirect_to(root_path) 
      end
    end
  end
  
end
