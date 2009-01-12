# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def current_school_session #untested, cargo cult
    #return @current_school_session if defined?(@current_school_session)
    @current_school_session = SchoolSession.find
  end

  def current_school #untested, cargo cult
    #return @current_school if defined?(@current_school)
    @current_school = current_school_session && current_school_session.school
  end
  
end
