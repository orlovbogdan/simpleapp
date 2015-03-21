class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize
  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  helper_method :admin?
  helper_method :current_user

  protected

  def authorize
    unless admin?
      flash[:error] = 'unauthorize access'
      redirect_to pages_path
    end
  end

  def autorize
    if !current_permission.allow?(params[:controller], params[:action], current_permission)
      redirect_to root_url, aler: "Not autorized."
    end
  end

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    nil
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
    unless @current_user
      @user = User.new_guest
      @user.save!
      @user
    end
  end

end
