class TeamsController < ApplicationController

  load_and_authorize_resource

  def print
    @school = @team.school
    render :layout => 'wide'
  end

end
