class GradingController < ApplicationController

  before_filter :is_admin?#, :except => [:statistics] # uncomment after tournament to let everyone see statistics
  before_filter :load_teams, :only => [:teams, :update_teams]
  before_filter :load_students, :only => [:students, :update_students]

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
    params[:level] ||= Student::WIZARD
    params[:class] ||= 'Large'

    @schools = School.send("#{params[:class].downcase}_schools", :include => {:teams => :students}).sort_by(&:school_score).reverse
    @schools.each { |s| s.teams.each { |t| t.school = s }} # prevents a query to database

    @teams = @schools.map(&:teams).flatten.select{ |t| t.level == params[:level] && t.students_count > 0 }.sort_by(&:team_score).reverse
    # TODO: This statement prevents extra queries, b/c the eager loading doesn't set the associations backwards
    # problem, though, is that this screws w/ the counter cache and takes longer, so isn't as simple as the
    # one above...
    #@teams.each { |t| t.students.each { |s| s.team = t }} # prevents a query to database

    @students = @teams.map(&:students).flatten.sort_by { |s| s.test_score || 0 }.reverse

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
    rank = Array.new(collection.size)
    rank[0] = 1
    size = 0;
    for i in 1...collection.size
      rank[i] = rank[i -1];
      if collection[i].send(method) == collection[i - 1].send(method)
        size += 1
      else
        rank[i] += size + 1
        size = 0
      end
    end
    rank
  end

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
