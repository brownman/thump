class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  layout 'site'
  
  helper_method :current_user
  helper_method :logged_in?
  before_filter :set_cache_buster
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def logged_in?
    !!current_user
  end
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
    
end