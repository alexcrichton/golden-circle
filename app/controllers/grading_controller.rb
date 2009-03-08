class GradingController < ApplicationController

  before_filter :require_admin
  before_filter :load_teams, :only => [:teams, :update_teams]
  before_filter :load_students, :only => [:students, :update_students]

  def print
    @team = Team.find(params[:id], :include => [:school, :students])
    @school = @team.school
    render :layout => 'admin'
  end

  def blanks
    @teams = Team.blank_scores
    @students = Student.blank_scores
  end

  def unchecked
    @unchecked_team_scores = Team.unchecked_team_score
    @unchecked_student_scores = Team.unchecked_student_scores
  end

  def teams
  end

  def update_teams
    params[:teams] ||= {}
    params[:teams].each_pair do |id, attrs|
      t = @team_hash[id.to_i]
      t.test_score = attrs['test_score'] if t.test_score != attrs['test_score']
      t.team_score_checked = attrs['team_score_checked'] if t.team_score_checked != attrs['team_score_checked']
      t.save if t.test_score != attrs['test_score'] || t.team_score_checked != attrs['team_score_checked']
    end
    render :action => 'teams'
  end

  def students
  end

  def update_students
    params[:students] ||= {}
    params[:students].each_pair do |id, student_attributes|
      s = @student_hash[id.to_i]
      next if s.test_score == student_attributes['test_score']
      s.test_score = student_attributes['test_score']
      s.save
    end
    if @team.student_scores_checked != params[:team][:student_scores_checked]
      @team.student_scores_checked = params[:team][:student_scores_checked]
      @team.save
    end
    render :action => 'students'
  end

  def config
  end

  protected

  def load_students
    @student_hash = {}
    @team = Team.find(params[:team_id], :include => [:students, :school])
    @students = @team.students.by_name
    @students.each { |s| @student_hash[s.id] = s }
  end

  def load_teams
    @team_hash = {}
    @teams = Team.send(params[:level].downcase).participating.sorted
    @teams.each { |t| @team_hash[t.id] = t}
  end

end
