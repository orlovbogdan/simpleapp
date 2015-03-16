class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
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