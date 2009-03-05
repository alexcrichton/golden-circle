class SchoolsController < ApplicationController

  before_filter :load_school
  before_filter :require_school, :only => [:show_current]
  before_filter :require_owner, :only => [:update, :edit, :destroy, :show]
  before_filter :require_admin, :only => [:index, :print, :email]

  def index
    @schools = School.all
    @large_schools = @schools.large
    @small_schools = @schools.small
    @unknown = @schools.unknown
    @proctors = @schools.collect{ |s| s.proctors }.flatten

    render :layout => 'admin'
  end

  def print
    @team = @school.teams.send("#{params[:level].downcase}").first
    render :layout => 'admin'
  end

  def email
    School.find(:all).each { |school| Notification.deliver_confirmation(school) }
    flash[:notice] = 'Emails have been sent!'
    redirect_to schools_path
  end

  def show
    render :action => 'edit'
  end

  def show_current
    @school = current_school
    render :action => 'edit'
  end

  def new
    @school = School.new
  end

  def create
    current_school_session.destroy if current_school_session
    @school = School.new(params[:school])

    if @school.save
      flash[:notice] = 'School was successfully created.'
      redirect_to(@school)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    # if the forms were all cleared, we have to make sure that attribute_fu knows this and the
    # attributes= methods are called with blank hashes so all items are deleted. If this is not
    # here, when all forms are deleted, no hash is passed here, and nothing is deleted.
    params[:school] ||= {}
    params[:school][:proctor_attributes] ||= {}

    params[:school][:team_attributes] ||= {}
    params[:school][:team_attributes].each_key do |key|
      params[:school][:team_attributes][key][:student_attributes] ||= {} if key.to_s.match(/^\d+$/)
    end

    if @school.update_attributes(params[:school])
      flash[:notice] = 'School was successfully updated. Please review the form below, it is what was saved in the database.'
      redirect_to(@school)
    else
      render :action => "edit"
    end
  end

  def destroy
    @school.destroy
    redirect_to(schools_path)
  end

  protected

  def load_school
    @school = School.find(params[:id], :include => [:teams, :students, :proctors]) if params[:id]
  end

  def require_owner
    unless current_school && @school && (@school.id == current_school.id || current_school.admin)
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

end
