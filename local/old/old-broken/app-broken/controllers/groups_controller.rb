class GroupsController < ApplicationController
  
  
#  def ssl_required?
#    true
#  end
  # example
  #ssl_required  :new, :create, :edit, :update, :destroy

  # Login Code
  # before_filter :admin, :except => [ :index, :new, :create, :update ]

  
  ### custom methods


  ### RESTful methods
  # GET /groups
  # GET /groups.xml
  def index
    if session[:admin]
		if params[:group_type]
			@groups = Group.where(:group_type => params[:group_type]).order( "groups.name ASC" )
		else
			@groups = Group.order( "groups.name ASC" )
		end
	else
		if params[:group_type]
			@groups = Group.joins(:people).where(:group_type => params[:group_type]).where("people.netid" => session[:netid]).order( "groups.name ASC" )
		else
			@groups = Group.joins(:people).where("people.netid" => session[:netid]).order( "groups.name ASC" )
		end
	end
	
	@tab_html = list_types()
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end


  # GET /groups/1
  # GET /groups/1.xml
#  def show
#    @group = Group.find(params[:id])
#		
#	respond_to do |format|
#	  format.html # show.html.erb
#	  format.xml  { render :xml => @contact }
#	end
#	
#  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /pages/copy
  def copy
    @existing_group = Group.find(params[:id])
    @group = Group.new(@existing_group.attributes.except('id'))
	@group.paths = @existing_group.paths
	@group.people = @existing_group.people
	
	if @group.tab_path 
		@tab_html = @group.tab_path.page.read.html_safe
	end
	
	if @group.category_path 
		@category_html = @group.category_path.page.read.html_safe
	end
	
	group.name = group.name + '_copy'
	
		
	@existing_group.paths.each do |path|
		path.path = path.path + '_copy'
		@page.paths << Path.new(path.attributes.except('id'))
	end
		

	
	respond_to do |format|
	  format.html # edit.html.erb
	  format.xml  { render :xml => @contact }
	end	
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
		
	@group_css = @group.stylesheet.html_safe	
		
	@tab_html = @group.tab_path.page.read.html_safe

	@category_html = @group.category_path.page.read.html_safe

	@group.welcome_path.page.read.html_safe		
	
	
	respond_to do |format|
	  format.html # edit.html.erb
	  format.xml  { render :xml => @contact }
	end
		
  end

  # POST /groups
  # POST /groups.xmldescribe paths
  def create
	@group = Group.new(group_params)
	
	
	respond_to do |format|
	  if ( @group.save )
		flash[:notice] = @group.name + ' has been created.'
		
		format.html { redirect_to( :action => 'index') }
		format.xml  { render :xml => @group, :status => :created, :location => @group }
	  else
		flash[:notice] = 'Something went wrong...'
		
		format.html { render :action => 'new' }
		format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
	  end
	end
	
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])
	
    respond_to do |format|
      if @group.update_attributes(group_params)
        flash[:notice] = 'Group was successfully updated.'
       # format.html { redirect_to( :action => 'show', :id => @group) }
	    format.html { redirect_to( :action => 'index' ) }
        format.xml  { head :ok }
	  	format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
	
	deleted_group = @group.name
    @group.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: "#{deleted_group} was deleted." }
      format.xml  { head :ok }
    end
  end
  
  
	def list_types(root_site='')
		rv = ""
		types = Group.select("distinct group_type").order("group_type ASC")
		type_selected = false
		
		types.each do |type|
			if type.group_type == params[:group_type]
				rv = rv + "<li><a href='/groups?group_type=" + type.group_type + "' class='selected'>" + type.group_type + "</a></li>"
				type_selected = true
			else
				rv = rv + "<li><a href='/groups?group_type=" + type.group_type + "'>" + type.group_type + "</a></li>"
			end
		end
		
		if type_selected
			rv = "<li><a href='/groups'>All Group Types</a></li>" + rv
			rv = "<ul>" + rv + "</ul>"
		else
			rv = "<li><a href='/groups' class='selected'>All Group Types</a></li>" + rv
			rv = "<ul>" + rv + "</ul>"
		end
		
		return rv.html_safe
	end
	
  
  
	def group_params
	    params.require(:group).permit(:id, :name, :group_type, :stylesheet, :tabs_id, :categories_id, :welcomes_id, :_destroy, 
	  		group_people_attributes: [:group_id, :id, :person_id, :role, :_destroy,
	  			people_attributes: [:id, :full_name]
			],
	  		group_paths_attributes: [:group_id, :id, :path_id, :_destroy,
	  			paths_attributes: [:id, :title]
			]
		)
			
	end
  
end

