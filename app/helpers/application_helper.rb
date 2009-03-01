# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_school_session #untested, cargo cult
    return @current_school_session if defined?(@current_school_session)
    @current_school_session = SchoolSession.find
  end

  def current_school #untested, cargo cult
    return @current_school if defined?(@current_school)
    @current_school = current_school_session && current_school_session.school
  end

  def require_school
    unless current_school
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_admin
    unless current_school && current_school.admin
      store_location
      flash[:notice] = "You must be an admin to view this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_school
    if current_school
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to current_school
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
