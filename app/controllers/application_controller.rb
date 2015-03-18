class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :admin?
  helper_method :current_user

  protected

  def authorize
    unless admin?
      flash[:error] = 'unauthorize access'
      redirect_to pages_path
    end
  end

  def admin?
    session[:password] == 'foobar'
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'foo' && password == 'bar'
    end
    http_basic_authenticate_with :name => "frodo", :password => "thering"
  end

  private

  def current_user
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

end
