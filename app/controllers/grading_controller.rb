class GradingController < ApplicationController

  before_filter :require_admin
  before_filter :load_teams, :only => [:teams, :update_teams]
  before_filter :load_students, :only => [:students, :update_students]
  layout 'wide'

  def print
    @team = Team.find(params[:id], :include => [:school])
    @school = @team.school
    render :layout => 'wide'
  end

  def status
    @blank_teams = Team.blank_scores.participating.sorted
    @blank_students = Student.blank_scores.by_name

    @unchecked_team_scores = Team.unchecked_team_score.participating.sorted
    @unchecked_student_scores = Team.unchecked_student_scores.participating.sorted
  end

  def teams
  end

  def update_teams
    boolean = true
    params[:teams].each_pair do |id, attrs|
      t = @team_hash[id.to_i]
      t.test_score = attrs['test_score']
      t.team_score_checked = attrs['team_score_checked']
      boolean = t.recalculate_team_score(false) && boolean if t.changed?
    end
    if boolean
      flash[:notice] = "Teams successfully updated!"
      redirect_to grading_teams_path(:level => params[:level])
    else
      render :action => 'teams'
    end
  end

  def students
  end

  def update_students
    boolean = nil
    params[:students].each_pair do |id, student_attributes|
      s = @student_hash[id.to_i]
      s.test_score = student_attributes['test_score']
      if s.changed?
        boolean = true if boolean.nil?
        boolean = s.save && boolean
      end
    end
    @team.student_scores_checked = params[:team][:student_scores_checked]
    if boolean.nil?
      # no students
      @team.recalculate_team_score(false) if @team.changed? # don't need to recalculate, just the check flag changed
    elsif boolean
      @team.recalculate_team_score #successful saves, score changed
    else
      return render(:action => 'students') # unsuccessful saves...
    end
    flash[:notice] = 'Students successfully updated!'
    redirect_to grading_students_path(:team_id => @team.id)
  end

  def config
  end

  def update_configuration
    event_date = convert_date(params[:settings], :event_date)
    Settings.event_date = event_date if event_date
    deadline = convert_date(params[:settings], :deadline)
    Settings.deadline = deadline if deadline
    Settings.cost_per_student = params[:settings][:cost_per_student].to_i if params[:settings][:cost_per_student]
    redirect_to grading_config_path
  end

  protected

  def convert_date(hash, key)
    args = (1..5).map { |n| val = hash["#{key}(#{n}i)"]; return nil if val.nil?; val}
    Time.zone.local(*args)
  end

  def load_students
    @student_hash = {}
    @team = Team.find(params[:team_id], :include => [:school])
    @students = @team.students.by_name
    @students.each { |s| @student_hash[s.id] = s }
  end

  def load_teams
    @team_hash = {}
    @teams = Team.send(params[:level].downcase).participating.sorted
    @teams.each { |t| @team_hash[t.id] = t}
  end

end
