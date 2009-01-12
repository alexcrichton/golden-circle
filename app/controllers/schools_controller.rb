class SchoolsController < ApplicationController
  
  before_filter :load_school
  before_filter :is_owner?, :only => [:update, :show, :destroy]
  before_filter :is_admin?, :only => [:index]
  
  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.find(:all, :order => ['name ASC'])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
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
    current_school_session.destroy unless current_school_session.nil?
    
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
    params[:school][:proctor_attributes] ||= {}
    
    params[:school][:team_attributes] ||= {}
#    [:wizard_team_attributes, :apprentice_team_attributes].each do |team|
#      params[:school][team] ||= {}
#      params[:school][team].each_key do |key|
#        params[:school][team][key][:student_attributes] ||= {} if key.to_s.match(/^\d+$/)
#      end
#    end
    params[:school][:team_attributes].each_key do |key|
      params[:school][:team_attributes][key][:student_attributes] ||= {} if key.to_s.match(/^\d+$/)
    end
    
    respond_to do |format|
      if @school.update_attributes(params[:school])
        flash[:notice] = 'School was successfully updated.'
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
    @school = School.find(params[:id]) if params[:id]
  end
  
  def is_owner?
    if current_school.nil? || @school.nil? || (@school.id != current_school.id && !current_school.admin?)
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
