class SchoolsController < ApplicationController
  
  before_filter :load_school
  before_filter :ensure_owner, :except => [:create, :new, :index]
  before_filter :ensure_admin, :only => [:index]
  
  # GET /schools
  def index
    @schools = School.find(:all, :order => 'name ASC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1
  def show
    respond_to do |format|
      format.html
    end
  end
  
  # GET /schools/new
  def new
    @school = School.new
    respond_to do |format|
      format.html
    end
  end

  # POST /schools
  def create
    current_school_session.destroy if current_school_session
    
    @school = School.new(params[:school])
    respond_to do |format|
      if @school.save
        flash[:notice] = 'School was successfully created. Please fill out the following information to complete your registration'
        format.html { redirect_to(@school) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # PUT /schools/1
  def update
    
    respond_to do |format|
      if @school.update_attributes(params[:school])
        flash[:notice] = 'School was successfully updated. You may update any time you like by visiting this website.'
        format.html { redirect_to(@school) }
      else
        format.html { render :action => "show" }
      end
    end
  end

  # DELETE /schools/1
  def destroy
    @school.destroy
    
    respond_to do |format|
      format.html { redirect_to(schools_url) }
    end
  end
  
  protected
  def load_school
    @school = School.find(params[:id]) if params[:id]
  end
  
  def ensure_owner
    if(@school.nil? || current_school.nil? || (current_school.id != @school.id && !current_school.admin))
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
  
  def ensure_admin
    if(current_school.nil? || !current_school.admin)
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
  
end
