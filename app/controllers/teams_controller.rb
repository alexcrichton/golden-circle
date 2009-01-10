class TeamsController < ApplicationController
  
  # before_filter :ensure_owner, :except => [:create]
  # before_filter :ensure_admin, :only => [:index]
  
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
    @team = Team.find(params[:id])

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
  
  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])
    
    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
      else
        format.html { render :action => "edit" }
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
  def ensure_owner
    if(@team.nil? || current_team.nil? || (current_team.id != @team.id && !current_team.admin))
      # redirect_to(denied_path)
    end
  end
  
  def ensure_owner
    if(current_team.nil? || !current_team.admin)
      # redirect_to(denied_path)
    end
  end
  
  def ensure_admin
  end
end
