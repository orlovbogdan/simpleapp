class SessionsController < ApplicationController
  def new
  end

  def create
    session[:password] = params[:password]
    redirect_to pages_path, notice: 'Successfully logged in'
  end

  def destroy
    reset_session
    redirect_to new_sessions_path
  end
end