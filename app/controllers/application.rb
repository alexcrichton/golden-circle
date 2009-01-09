# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '2bc5e62fe0ec71976a2d8a0bc2328c5b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def current_team_session #untested, cargo cult
    return @current_team_session if defined?(@current_team_session)
    @current_team_session = TeamSession.find
  end

  def current_team #untested, cargo cult
    return @current_team if defined?(@current_team)
    @current_team = current_team_session && current_team_session.user
  end
  
end
