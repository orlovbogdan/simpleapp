class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  helper_method :current_user


  #helper_method :admin?

  #def authorize
  #  unless admin?
  #    flash[:error] = 'unauthorize access'
  #    redirect_to pages_path
  #  end
  #end

  #def admin?
  #  session[:password] == 'foobar'
  #end

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    username == 'foo' && password == 'bar'
  #  end
  #  http_basic_authenticate_with :name => "frodo", :password => "thering"
  #end

  protected

  def authorize
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

  private

  def current_user
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= (User.where(auth_token: cookies[:auth_token]).first if cookies[:auth_token])
    unless @current_user
      @current_user = User.new_guest
      @current_user.save!
      #session[:user_id] = @current_user.id
      cookies[:auth_token] = @current_user.auth_token
      @current_user
    end
    @current_user
  end

end
