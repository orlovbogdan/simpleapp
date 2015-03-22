class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(users_params) : User.new_guest
    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      #session[:user_id] = @user.id
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  protected
    def users_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
