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
      return render :action => 'students' # unsuccessful saves...
    end
    flash[:notice] = 'Students successfully updated!'
    redirect_to grading_students_path(:team_id => @team.id)
  end

  def config
    @deadline = Settings.find_by_var('deadline')
    @event_date = Settings.find_by_var('event_date')
    @cost_per_student = Settings.find_by_var('cost_per_student')
  end

  def update_configuration
    event_date = convert_date(params[:settings], :event_date)
    Settings.event_date = event_date if event_date
    deadline = convert_date(params[:settings], :deadline)
    Settings.deadline = deadline if deadline
    Settings.cost_per_student = params[:settings][:cost_per_student].to_i if params[:settings][:cost_per_student]
    redirect_to grading_config_path
  end

  def upload
    unless params[:upload].blank?
      path = File.join('public', 'golden_circle_information.pdf')
      File.delete(path)
      File.open(path, "wb") { |f| f.write(params[:upload].read)}
      flash[:notice] = 'File successfully uploaded!'
    end
    redirect_to grading_config_path
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
      redirect_to grading_config_path
    end
  end

  def restore_database
    if params[:upload].blank?
      flash[:error] = 'You need to restore from a file!'
      return redirect_to(grading_config_path)
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
