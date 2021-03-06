class Grading::TeamsController < ApplicationController
  
  before_filter { |c| c.authorize! :grade, School }
  before_filter :load_teams
  layout 'wide'

  def show
  end

  def update
    boolean = true
    params[:teams].each_pair do |id, attrs|
      t = @team_hash[id.to_i]
      t.test_score = attrs['test_score']
      t.team_score_checked = attrs['team_score_checked']
      boolean = t.recalculate_team_score(false) && boolean if t.changed?
    end
    if boolean
      flash[:notice] = "Teams successfully updated!"
      redirect_to grading_team_path(params[:id])
    else
      render :action => 'show'
    end
  end

  protected

  def load_teams
    params[:id] = 'wizard' unless params[:id] =~ /\Aapprentice\z/i
    @team_hash = {}
    @teams = Team.send(params[:id].downcase).participating.sorted
    @teams.each { |t| @team_hash[t.id] = t }
  end

end
