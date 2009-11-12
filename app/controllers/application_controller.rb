# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  filter_parameter_logging :password, :password_confirmation, :perishable_token, :persistence_token

  include ApplicationHelper

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '2bc5e62fe0ec71976a2d8a0bc2328c5b'

end
