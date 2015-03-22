class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @users = User.search(params[:search]).page(params[:page]).order( sort_column + ' ' +  sort_direction)  #.per(5)  #.per_page(5)
  end

  def show
    @user = current_user
  end

  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
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

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : 'email'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

end
