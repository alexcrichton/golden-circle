class GradingController < ApplicationController
  
  before_filter :is_admin?
  before_filter :load_teams, :except => [:statistics]
  before_filter :load_students, :only => [:students, :update_students]
  layout 'admin'
  
  def teams
  end
  
  def update_teams
    params[:teams] ||= {}
    params[:teams].each_pair do |i, v|
      t = @team_hash[i.to_i]
      t.test_score = v['test_score']
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
    render :action => 'students'
  end
  
  def statistics
    @sort = {:level => Student::WIZARD, :class => 'Large'}
    @sort[:level] = params[:level] if params[:level]
    @sort[:class] = params[:class] if params[:class]
    
    @schools = School.send("#{@sort[:class].downcase}_schools").sort_by(&:school_score).reverse
    @teams = @schools.map { |s| s.teams.find(:first, :conditions => ['level = ?', @sort[:level]])}.sort_by(&:team_score).reverse
    @students = @teams.map { |t| t.students }.flatten.sort_by { |s| s.test_score || 0 }.reverse
    
    @teams_rank = rank(@teams, :team_score)
    @schools_rank = rank(@schools, :school_score)
    @students_rank = rank(@students, :test_score)
  end
  
  protected
  def is_admin?
    if current_school.nil? || !current_school.admin
      flash[:error] = "Sorry, but you don't have access to here"
      redirect_to root_path
    end
  end
  
  def rank(collection, method)
    puts collection
    rank = Array.new(collection.size)
    rank[0] = 1
    size = 0;
    for i in 1...collection.size
      puts i
      off = 1
      if collection[i].send(method) == collection[i - 1].send(method)
        size += 1
        off = 0
      else
        size = 1
      end
      rank[i] = rank[i - 1] + off
    end
    rank
  end
  
  def load_students
    @student_hash = {}
    @small_app = @small_app.map { |t| t.students }.flatten
    @small_wiz = @small_wiz.map { |t| t.students }.flatten
    @large_app = @large_app.map { |t| t.students }.flatten
    @large_wiz = @large_wiz.map { |t| t.students }.flatten
    @students = [@small_app, @small_wiz, @large_app, @large_wiz].flatten
    @students.each { |s| @student_hash[s.id] = s }
    @team_hash = nil 
  end
  
  def load_teams
    schools = School.small_schools
    @team_hash = {}
    @small_app = schools.map { |s| s.apprentice_team }
    @small_wiz = schools.map { |s| s.wizard_team }
    schools = School.large_schools
    @large_app = schools.map { |s| s.apprentice_team }
    @large_wiz = schools.map { |s| s.wizard_team }
    @teams = [@small_app, @small_wiz, @large_app, @large_wiz].flatten
    @teams.each { |t| @team_hash[t.id] = t} 
  end
  
end
