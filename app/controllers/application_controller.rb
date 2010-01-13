class ApplicationController < ActionController::Base

  filter_parameter_logging :password, :password_confirmation 

  helper :all # include all helpers, all the time

  protect_from_forgery

  helper_method :current_school, :current_school_session

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied.'
    store_location unless current_school
    redirect_to current_school ? root_url : login_url
  end

  protected

  def current_school_session 
    return @current_school_session if defined?(@current_school_session)
    @current_school_session = SchoolSession.find
  end

  def current_school 
    return @current_school if defined?(@current_school)
    @current_school = current_school_session && current_school_session.school
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    clear_stored_location
  end

  def current_user # for CanCan
    current_school
  end
end
