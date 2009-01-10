class TeamsController < ApplicationController
  
  before_filter :load_team
  before_filter :ensure_owner, :except => [:create, :new]
  before_filter :ensure_admin, :only => [:index]
  
  # GET /teams
  def index
    @teams = Team.find(:all, :order => 'enrollment DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end
  
  # GET /teams/1
  def show
    respond_to do |format|
      format.html
    end
  end
  
  # GET /teams/new
  def new
    @team = Team.new
    respond_to do |format|
      format.html
    end
  end

  # POST /teams
  def create
    current_team_session.destroy if current_team_session
    
    @team = Team.new(params[:team])
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(@team) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # PUT /teams/1
  def update
    
    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
      else
        format.html { render :action => "show" }
      end
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    
    respond_to do |format|
      format.html { redirect_to(teams_url) }
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
