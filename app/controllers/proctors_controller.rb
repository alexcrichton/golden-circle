class ProctorsController < ApplicationController
  # GET /proctors
  # GET /proctors.xml
  def index
    @proctors = Proctor.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proctors }
    end
  end

  # GET /proctors/1
  # GET /proctors/1.xml
  def show
    @proctor = Proctor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proctor }
    end
  end

  # GET /proctors/new
  # GET /proctors/new.xml
  def new
    @proctor = Proctor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proctor }
    end
  end

  # GET /proctors/1/edit
  def edit
    @proctor = Proctor.find(params[:id])
  end

  # POST /proctors
  # POST /proctors.xml
  def create
    @proctor = Proctor.new(params[:proctor])

    respond_to do |format|
      if @proctor.save
        flash[:notice] = 'Proctor was successfully created.'
        format.html { redirect_to(@proctor) }
        format.xml  { render :xml => @proctor, :status => :created, :location => @proctor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proctor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proctors/1
  # PUT /proctors/1.xml
  def update
    @proctor = Proctor.find(params[:id])

    respond_to do |format|
      if @proctor.update_attributes(params[:proctor])
        flash[:notice] = 'Proctor was successfully updated.'
        format.html { redirect_to(@proctor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proctor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proctors/1
  # DELETE /proctors/1.xml
  def destroy
    @proctor = Proctor.find(params[:id])
    @proctor.destroy

    respond_to do |format|
      format.html { redirect_to(proctors_url) }
      format.xml  { head :ok }
    end
  end
end
