class SchoolsController < ApplicationController

  before_filter :load_school
  authorize_resource

  def index
    @schools = School.all.by_name
    @large_schools = @schools.large
    @small_schools = @schools.small
    @unknown = @schools.unknown
    @proctors = @schools.collect{ |s| s.proctors }.flatten

    render :layout => 'wide'
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
    render :layout => 'wide' if current_school.nil?
  end

  def create
    @school = School.new(params[:school])

    if @school.save
      flash[:notice] = 'School was successfully created.'
      redirect_to(@school)
    elsif current_school && current_school.admin && @school.errors.size == 1 && @school.errors.on_base != nil
      @school.save(false)
      redirect_to(@school)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    params[:school].delete(:password)
    params[:school].delete(:password_confirmation)
    if @school.update_attributes(params[:school])
      flash[:notice] = 'School successfully updated. Please review the form below to ensure accuracy.'
      redirect_to(@school)
    else
      render :action => "edit"
    end
  end

  def destroy
    @school.destroy
    redirect_to(schools_path)
  end
  
  def valid
    @field = params[:field].to_sym
    @school = School.new(params[:school])
    if params[:default] == @school[@field]
      render :text => 'true'
    else
      @school.valid? # get errors if they exist
      render :text => (@school.errors.on(@field).blank? ? 'true' : 'false')
    end
  end

  protected

  def load_school
    @school = School.find_by_slug(params[:id], :include => [:teams, :proctors]) if params[:id]
    @school = current_school if @school.nil?
  end

end
