# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def current_team_session #untested, cargo cult
    return @current_team_session if defined?(@current_team_session)
    @current_team_session = TeamSession.find
  end

  def current_team #untested, cargo cult
    return @current_team if defined?(@current_team)
    @current_team = current_team_session && current_team_session.team
  end
  
end
