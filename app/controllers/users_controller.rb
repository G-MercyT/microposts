class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts
  end
    
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(profile_params)
      redirect_to @user, notice: 'プロフィールが更新されました'
    else
      render 'edit'
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @following = @user.following_users
  end
  
  def followers
    @user = User.find(params[:id])
    @follower = @user.follower_users
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmataion)
  end
  
  def profile_params
    params.require(:user).permit(:name, :email, :description, :area)
  end
end
