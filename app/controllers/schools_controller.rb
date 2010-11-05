class SchoolsController < ApplicationController

  respond_to :html, :except => :valid
  load_and_authorize_resource :find_by => :slug

  def index
    @schools       = School.by_name
    @proctors      = @schools.collect{ |s| s.proctors }.flatten
    @large_schools = @schools.select &:large?
    @small_schools = @schools.select &:small?
    @unknown       = @schools.select &:unknown?

    respond_with @schools
  end

  def new
    respond_with @school
  end

  def edit
    respond_with @school
  end

  def show
    respond_with @school do |format|
      format.html{ render :action => 'edit' }
    end
  end

  def create
    @school.save

    respond_with @school
  end

  def update
    @school.update_attributes params[:school]

    respond_with @school
  end

  def destroy
    @school.destroy

    respond_with @school
  end

  def email
    School.all.each { |school| Notifier.confirmation(school).deliver }
    flash[:notice] = 'Emails have been sent!'
    redirect_to schools_path
  end

  def show_current
    @school = current_school

    respond_with @school do |format|
      format.html{ render :action => 'edit' }
    end
  end
  
  def valid
    @field = params[:field].to_sym
    @school = School.new(params[:school])

    if params[:default] == @school[@field]
      valid = true
    else
      @school.valid? # get errors if they exist
      valid = @school.errors[@field].blank?
    end

    respond_with valid do |format|
      format.json { render :json => valid }
    end
  end

  def admin
    @school.admin = params[:school][:admin]
    if @school.save
      render :text => 'success'
    else 
      render :text => 'failure'
    end
  end

end
