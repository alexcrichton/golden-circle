class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Access denied.'

    redirect_to current_school ? root_path : new_school_session_path
  end

  protected

  def current_user # for CanCan
    current_school
  end

  def after_sign_out_path_for scope
    new_school_session_path
  end
end
