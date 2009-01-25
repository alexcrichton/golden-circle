class SchoolsController < ApplicationController
  
  before_filter :load_school
  before_filter :is_owner?, :only => [:update, :show, :destroy]
  before_filter :is_admin?, :only => [:index, :print, :email]
  
  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.find(:all, :include => [:proctors, :teams, :students])
    @large_schools = []
    @small_schools = []
    @unknown = []
    @schools.each do |s|
      case s.school_class
      when 'Large School'
        @large_schools << s
      when 'Small School'
        @small_schools << s
      else
        @unknown << s
      end
    end
    @proctors = @schools.collect{ |s| s.proctors }.flatten
    
    respond_to do |format|
      format.html { render :action => 'index', :layout => 'admin' }
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1/print
  def print
    @team = @school.teams.detect { |t| t.level.downcase == params[:level].downcase }
    respond_to do |format|
      format.html { render :action => 'print', :layout => 'admin'}
    end
  end
  
  def email
    School.find(:all).each { |school| Notification.deliver_confirmation(school) }
    flash[:notice] = 'Emails have been sent!'
    redirect_to schools_path
  end

  # GET /schools/1
  # GET /schools/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  # POST /schools
  # POST /schools.xml
  def create
    current_school_session.destroy if current_school_session
    @school = School.new(params[:school])
    
    respond_to do |format|
      if @school.save
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(@school) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
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
    
    respond_to do |format|
      if @school.update_attributes(params[:school])
        flash[:notice] = 'School was successfully updated. Please review the form below, it is what was saved in the database.'
        format.html { redirect_to(@school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school.destroy
    
    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def load_school
    @school = School.find(params[:id], :include => [:teams, :students, :proctors]) if params[:id]
  end
  
  def is_owner?
    if current_school.nil? || @school.nil? || (@school.id != current_school.id && !current_school.admin)
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
  
  def is_admin?
    if current_school.nil? || !current_school.admin?
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
end
