class TeamsController < ApplicationController
  
  before_filter :load_team
  before_filter :ensure_owner, :except => [:create]
  before_filter :ensure_admin, :only => [:index]
  
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.find(:all, :order => 'enrollment DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end
  
  def new
    @team = Team.new
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    render :action => 'edit'
#    @team = Team.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @team }
#    end
  end

  # GET /teams/new
  # GET /teams/new.xml
 # def new
 #   @team = Team.new
 # 
 #   respond_to do |format|
 #     format.html # new.html.erb
 #     format.xml  { render :xml => @team }
 #   end
 # end

  # GET /teams/1/edit
#  def edit
#    @team = Team.find(params[:id])
#  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        current_team = @team
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(@team) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    params[:proctors].each_pair do |id, hash|
      if id == '0'
        team.proctors << Proctor.new(hash)
      else
        p = Proctor.find(id)
        p.update_attributes(hash)
        p.destroy if hash[:name].blank?
      end
    end
    
    params[:students].each_pair do |id, hash|
      if id == '0'
        team.students << Student.new(hash)
      else
        s = Student.find(id)
        s.update_attributes(hash)
        s.destroy if hash[:first_name].blank?
      end
    end
    
    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team.destroy
    
    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def load_team
    @team = Team.find(params[:id]) if params[:id]
  end
  
  def ensure_owner
    if(@team.nil? || current_team.nil? || (current_team.id != @team.id && !current_team.admin))
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
  
  def ensure_admin
    if(current_team.nil? || !current_team.admin)
      flash[:error] = 'Access Denied'
      redirect_to root_path
    end
  end
end
