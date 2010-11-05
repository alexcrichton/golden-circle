class SchoolsController < ApplicationController

  load_and_authorize_resource :find_by => :slug

  def index
    @schools = School.everything.by_name
    @large_schools = @schools.large
    @small_schools = @schools.small
    @unknown = @schools.unknown
    @proctors = @schools.collect{ |s| s.proctors }.flatten

    render :layout => 'wide'
  end

  def email
    School.all.each { |school| Notification.confirmation(school).deliver }
    flash[:notice] = 'Emails have been sent!'
    redirect_to schools_path
  end

  def show_current
    @school = current_school
    render :template => 'devise/registrations/edit'
  end
  
  def valid
    @field = params[:field].to_sym
    @school = School.new(params[:school])
    if params[:default] == @school[@field]
      render :text => 'true'
    else
      @school.valid? # get errors if they exist
      render :text => (@school.errors[@field].blank? ? 'true' : 'false')
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
