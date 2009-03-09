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
    boolean = true
    params[:teams].each_pair do |id, attrs|
      t = @team_hash[id.to_i]
      t.test_score = attrs['test_score'] if t.test_score != attrs['test_score']
      t.team_score_checked = attrs['team_score_checked'] if t.team_score_checked != attrs['team_score_checked']
      boolean = t.save && boolean if t.test_score != attrs['test_score'] || t.team_score_checked != attrs['team_score_checked']
    end
    if boolean
      flash[:notice] = "Teams successfully updated!"
    end
    render :action => 'teams'
  end

  def students
  end

  def update_students
    params[:students] ||= {}
    boolean = true
    params[:students].each_pair do |id, student_attributes|
      s = @student_hash[id.to_i]
      next if s.test_score == student_attributes['test_score']
      s.test_score = student_attributes['test_score']
      boolean = s.save && boolean
    end
    if @team.student_scores_checked != params[:team][:student_scores_checked]
      @team.student_scores_checked = params[:team][:student_scores_checked]
      boolean = @team.save && boolean
    end
    if boolean
      flash[:notice] = 'Students successfully updated!'
    end
    render :action => 'students'
  end

  def config
  end

  def update_configuration
    event_date = convert_date(params[:settings], :event_date)
    Settings.event_date = event_date if event_date
    deadline = convert_date(params[:settings], :deadline)
    Settings.deadline = deadline if deadline
    Settings.cost_per_student = params[:settings][:cost_per_student].to_i if params[:settings][:cost_per_student]
    render :action => 'config'
  end

  def upload
    unless params[:upload].blank?
      path = File.join('public', 'golden_circle_information.pdf')
      File.delete(path)
      File.open(path, "wb") { |f| f.write(params[:upload].read)}
      flash[:notice] = 'File successfully uploaded!'
    end
    render :action => 'config'
  end

  def backup_database
    config = School.configurations[RAILS_ENV].symbolize_keys
    if config[:adapter] == 'mysql'
      send_data `mysqldump #{config[:database]} -u #{config[:username]} --password="#{config[:password]}"`,
                :filename => "gc_backup-#{Time.now.year}-#{Time.now.month}-#{Time.now.day}.sql"
    elsif config[:adapter] == 'sqlite3'
      send_data `sqlite3 #{config[:database]} '.dump'`,
                :filename => "gc_backup-#{Time.now.year}-#{Time.now.month}-#{Time.now.day}.sql"
    else
      flash[:error] = "Sorry, I don't know how to back up this kind of database"
      render :action => 'config'
    end
  end

  def restore_database
    if params[:upload].blank?
      flash[:error] = 'You need to restore from a file!'
      return render :action => 'config'
    end
    path = File.join('tmp', 'restore.sql')
    File.open(path, "wb") { |f| f.write(params[:upload].read) }
    config = School.configurations[RAILS_ENV].symbolize_keys
    if config[:adapter] == 'mysql'
      flash[:notice] = `mysql -u #{config[:username]} --password="#{config[:password]} -D #{config[:database]} < #{path}"`
    elsif config[:adapter] == 'sqlite3'
      flash[:notice] = `sqlite3 #{config[:database]} < #{path}`
    else
      flash[:error] = "Sorry, I don't know how to restore this kind of database"
    end
    File.delete(path)
    render :action => 'config'
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
