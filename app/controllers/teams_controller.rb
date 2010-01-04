class TeamsController < ApplicationController

  def print
    @team = Team.find(params[:id], :include => [:school])
    @school = @team.school
    render :layout => 'wide'
  end

end
