class GradingController < ApplicationController

  before_filter :require_admin
  before_filter :load_teams, :only => [:teams, :update_teams]
  before_filter :load_students, :only => [:students, :update_students]

  def teams
  end

  def update_teams
    params[:teams] ||= {}
    params[:teams].each_pair do |i, v|
      t = @team_hash[i.to_i]
      t.test_score = v['test_score']
      t.team_score_checked = v['team_score_checked']
      t.save
    end
    render :action => 'teams'
  end

  def students
  end

  def update_students
    params[:students] ||= {}
    params[:students].each_pair do |i, v|
      s = @student_hash[i.to_i]
      s.test_score = v['test_score']
      s.save
    end
    @team.student_scores_checked = params[:team][:student_scores_checked]
    @team.save
    render :action => 'students'
  end

  def config  
  end


  protected

  def load_students
    @student_hash = {}
    @team = Team.find(params[:team_id], :include => [:students, :school])
    @students = @team.students
    @students.each { |s| @student_hash[s.id] = s }
  end

  def load_teams
    @team_hash = {}
    @teams = Team.find(:all,
                       :include => [:school],
                       :conditions => ['level = ? AND students_count > ?', params[:level], 0],
                       :order => "schools.name ASC")
    @teams.each { |t| @team_hash[t.id] = t}
  end

end
