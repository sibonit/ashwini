class WallsController < ApplicationController

  def ssl_required?
    true
  end

  # Login Code
  # before_filter :admin, :except => [ :index, :show, :edit, :update ]

  # GET /walls
  # GET /walls.xml
  def index
    @new_wall = Wall.new
    @walls = Wall.all

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @walls }
    end
  end

  # GET /walls/1
  # GET /walls/1.xml
  def show
    @wall = Wall.find(params[:id])
	@comment = Comment.new( :wall => @wall )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @wall }
    end
  end

  # GET /walls/1/edit
  def edit
    @wall = Wall.find(params[:id])
	
    respond_to do |format|
      format.html { render :layout => 'sib.html' }
    end
  end

  # POST /walls
  # POST /walls.xml
  def create
    @wall = Wall.new(wall_params)

    respond_to do |format|
      if @wall.save
        format.html { redirect_to(@wall, :notice => 'Wall was successfully created.') }
        format.xml  { render :xml => @wall, :status => :created, :location => @wall }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wall.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /walls/1
  # PUT /walls/1.xml
  def update
    @wall = Wall.find(params[:id])

    respond_to do |format|
      if @wall.update_attributes(wall_params)
        format.html { redirect_to(@wall, :notice => 'Wall was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wall.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /walls/1
  # DELETE /walls/1.xml
  def destroy
    @wall = Wall.find(params[:id])
    @wall.destroy

    respond_to do |format|
      format.html { redirect_to(walls_url) }
      format.xml  { head :ok }
    end
  end
  
  def wall_params
	  params.require(:wall).permit(:name, :description)
  end
end
