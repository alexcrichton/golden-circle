class SchoolsController < ApplicationController

  before_filter :load_school
  before_filter :require_school, :only => [:show_current]
  before_filter :require_owner, :only => [:update, :edit, :destroy, :show]
  before_filter :require_admin, :only => [:index, :email]

  def index
    @schools = School.all.by_name
    @large_schools = @schools.large
    @small_schools = @schools.small
    @unknown = @schools.unknown
    @proctors = @schools.collect{ |s| s.proctors }.flatten

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
    @school = School.new(params[:school])

    save_worked = @school.save
    # if after deadline, only admin can change things. If the only error is on the base (creation deadline), then
    # allow this to pass by bypassing the one creation validation
    if !save_worked && current_school && current_school.admin && @school.errors.size == 1 && @school.errors.on_base != nil
      @school.save(false)
      save_worked = true
    end

    if save_worked
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
    params[:school][:proctor_attributes] ||= {}
    (params[:school][:team_attributes] ||= {}).each_pair do |team_id, team_attributes|
      team_attributes[:student_attributes] ||= {} if team_id.to_s.match(/^\d+$/)
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
    @school = School.find(params[:id], :include => [:teams, :proctors]) if params[:id]
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
