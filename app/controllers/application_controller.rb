class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied.'
    store_location unless current_school
    redirect_to current_school ? root_path : new_school_session_path
  end

  protected

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_default default
    redirect_to(session[:return_to] || default)
    clear_stored_location
  end

  def current_user # for CanCan
    current_school
  end
end
