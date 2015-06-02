class PagesController < ApplicationController
  
  
  #def ssl_required?
  #  true
  #end
  # example
  #ssl_required  :new, :create, :edit, :update, :destroy

  # Login Code
  # before_filter :admin, :except => [ :show ]

  
  # GET /pages
  # GET /pages.xml
  def index
  	if params[:page_type]
    	@pages = Page.where(:page_type => params[:page_type]).order( "title ASC" )
	else
    	@pages = Page.order( "page_type ASC, title ASC" )
	end
	
	@tab_html = list_types()
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
      format.csv  { render :action => 'spreadsheet.html', :layout => 'spreadsheet' }
    end
  end


  # GET /pages/1
  # GET /pages/1.xml
  def show
    # @page = Page.find(params[:id])
    #path = '/static' + request.path
	if current_path = Path.where(path: params[:path]).take
		@page = Page.find(current_path.page_id)
		
		@page.read
		@page.current_path = current_path
		

		@access = Person.joins(groups: :paths).where("groups.group_type = 'Access'").where("paths.path" => params[:path]).find_by_netid( session[:netid] )
		

		
		if @page.current_path.stylesheet_group
			@group_css = @page.current_path.stylesheet_group.stylesheet.html_safe
		end		
		
		if @page.current_path.tab_group
			if @page.current_path.tab_group.tab_path
				@tab_html = @page.current_path.tab_group.tab_path.page.read.html_safe
			end		
		end		

		if @page.current_path.category_group
			if @page.current_path.category_group.category_path
				@category_html = @page.current_path.category_group.category_path.page.read.html_safe
			end		
		end	

		if @page.current_path.welcome_group && @page.current_path.welcome_group.welcome_path
			@welcome_html = @page.current_path.welcome_group.welcome_path.page.read.html_safe	
		end	
		
		respond_to do |format|
		  format.xml  { render :xml => @contact }
		  format.any  { render :layout => 'application.html' } # show.html.erb
		end
	else
		render '/static/404.html'
	end
	
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
	
	@page.paths.build
		
		if session[:admin]
			@page.tab_options = Group.where("tabs_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.where("categories_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.where("stylesheet <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.where("welcomes_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		else
			@page.tab_options = Group.joins(:people).where("groups.tabs_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.joins(:people).where("groups.categories_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.joins(:people).where("groups.stylesheet <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.joins(:people).where("groups.welcomes_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		end

    respond_to do |format|
      format.html # new.html.erb
	  format.js
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/copy
  def copy
    
	if current_path = Path.where(path: params[:path]).take
		@existing_page = Page.find(current_path.page_id)
		@page = Page.new(@existing_page.attributes.except('id'))
		@page.read
		@page.parse_types
		@page.current_path = current_path
		
		@page.location = @page.location + '_copy'
		
		@existing_page.paths.each do |path|
			path.path = path.path + '_copy'
			@page.paths << path.clone_with_associations
		end
		
		if @page.current_path.stylesheet_group
			@group_css = @page.current_path.stylesheet_group.stylesheet.html_safe
		end		
		
		if @page.current_path.tab_group
			if @page.current_path.tab_group.tab_path
				@tab_html = @page.current_path.tab_group.tab_path.page.read.html_safe
			end		
		end		

		if @page.current_path.category_group
			if @page.current_path.category_group.category_path
				@category_html = @page.current_path.category_group.category_path.page.read.html_safe
			end		
		end	

		if @page.current_path.welcome_group && @page.current_path.welcome_group.welcome_path
			@welcome_html = @page.current_path.welcome_group.welcome_path.page.read.html_safe	
		end	
		
		if session[:admin]
			@page.tab_options = Group.where("tabs_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.where("categories_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.where("stylesheet <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.where("welcomes_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		else
			@page.tab_options = Group.joins(:people).where("groups.tabs_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.joins(:people).where("groups.categories_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.joins(:people).where("groups.stylesheet <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.joins(:people).where("groups.welcomes_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		end

		respond_to do |format|
		  format.html # copy.html.erb
		end
	else
		render '/static/404.html'
	end
	
  end

  # GET /pages/1/edit
  def edit
    
	if current_path = Path.where(path: params[:path]).take	
		@page = Page.find(current_path.page_id)
		@page.read
		@page.parse_types
		@page.current_path = current_path
		@page_type = @page.page_type
		
		if @page.current_path.stylesheet_group
			@group_css = @page.current_path.stylesheet_group.stylesheet.html_safe
		end		
		
		if @page.current_path.tab_group
			if @page.current_path.tab_group.tab_path
				@tab_html = @page.current_path.tab_group.tab_path.page.read.html_safe
			end		
		end		

		if @page.current_path.category_group
			if @page.current_path.category_group.category_path
				@category_html = @page.current_path.category_group.category_path.page.read.html_safe
			end		
		end	

		if @page.current_path.welcome_group && @page.current_path.welcome_group.welcome_path
			@welcome_html = @page.current_path.welcome_group.welcome_path.page.read.html_safe	
		end	
		
		if session[:admin]
			@page.tab_options = Group.where("tabs_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.where("categories_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.where("stylesheet <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.where("welcomes_id <> ''").select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		else
			@page.tab_options = Group.joins(:people).where("groups.tabs_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.category_options = Group.joins(:people).where("groups.categories_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.stylesheet_options = Group.joins(:people).where("groups.stylesheet <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
			@page.welcome_options = Group.joins(:people).where("groups.welcomes_id <> ''").where("people.netid=:netid", :netid => session[:netid]).select('groups.name, groups.id').order("groups.name ASC").collect {|x| [x.name, x.id]}
		end
		
		respond_to do |format|
		  format.html # edit.html.erb
		  format.xml  { render :xml => @contact }
		end
	else
		render '/static/404.html'
	end
	
  end

  # POST /pages
  # POST /pages.xmldescribe paths
  def create
	@page = Page.new(page_params)
	
		
	@page.tab_options = Page.where(page_type: :Tabs).collect {|x| [x.title, x.id]}
	@page.category_options = Page.where(page_type: :Categories).collect {|x| [x.title, x.id]}
	
	respond_to do |format|
	  if ( @page.save )
		flash[:notice] = @page.title + ' has been put online at ' + @page.location
		
		format.html { redirect_to( :action => 'index') }
		format.xml  { render :xml => @page, :status => :created, :location => @page }
	  else
		flash[:notice] = 'Something went wrong...'
		
		format.html { render :action => 'new' }
		format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
	  end
	end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])
		
    respond_to do |format|
      if @page.update_attributes(page_params)
        flash[:notice] = 'Page was successfully updated.'
       # format.html { redirect_to( :action => 'show', :id => @page) }
	    format.html { redirect_to( :action => 'index' ) }
        format.xml  { head :ok }
	  	format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
  
	if current_path = Path.where(path: params[:path]).take
		@page = Page.find(current_path.page_id)
   		@page.destroy

		respond_to do |format|
          flash[:notice] = 'Page was successfully deleted.'
		  format.html { redirect_to( :back ) }
		  format.xml  { head :ok }
		end
	else
		respond_to do |format|
          flash[:notice] = 'Page was not deleted.'
		  format.html { redirect_to( :back ) }
		  format.xml  { head :ok }
		end
	end
  end


	
	def list_types(root_site='')
		rv = ""
		types = Page.select("distinct page_type").order("page_type ASC")
		type_selected = false
		
		types.each do |type|
			if type.page_type == params[:page_type]
				rv = rv + "<li><a href='/pages?page_type=" + type.page_type + "' class='selected'>" + type.page_type + "</a></li>"
				type_selected = true
			else
				
				rv = rv + "<li><a href='/pages?page_type=" + type.page_type + "'>" + type.page_type + "</a></li>"
			end
		end
		
		if type_selected
			rv = "<li><a href='/pages'>All Page Types</a></li>" + rv
			rv = "<ul>" + rv + "</ul>"
		else
			rv = "<li><a href='/pages' class='selected'>All Page Types</a></li>" + rv
			rv = "<ul>" + rv + "</ul>"
		end
		
		return rv.html_safe
	end
	
	def update_tabs
		if params[:tab_path] != "";
			if current_path = Group.find(params[:tab_path]).tab_path
				@tab_html = current_path.page.read.html_safe	
				@tab_header = current_path.page.title.html_safe
			end
		else
			@tab_html = ""
			@tab_header = ""
		end
		
		respond_to do |format|
	  		format.js
    	end
	end
	
	def update_categories
		if params[:category_path] != "";
			if current_path = Group.find(params[:category_path]).category_path
				@category_html = current_path.page.read.html_safe	
				@category_header = current_path.page.title.html_safe
			end
		else
			@category_html = ""
			@category_header = ""
		end
		
		respond_to do |format|
	  		format.js
    	end
	end
	
	def update_stylesheet
		if params[:stylesheet] != "";
			@group_css = Group.find(params[:stylesheet]).stylesheet.html_safe
		else
			@group_css = "none"
		end
		
		respond_to do |format|
	  		format.js
    	end
	end
	
	def update_welcome
		if params[:welcome_path] != "";
			if current_path = Group.find(params[:welcome_path]).welcome_path
				@welcome_html = current_path.page.read.html_safe	
			end
		else
			@welcome_html = ""
		end
		
		respond_to do |format|
	  		format.js
    	end
	end
	
	def update_person
		if params[:person_id] != "";
			@person = Person.find(params[:person_id])		
		end
		
		respond_to do |format|
	  		format.js
    	end
	end
	
	def update_membership
		@people = Person.joins(:group_people).where("group_people.group_id" => params[:membership_id]).where("group_people.role" => "Member")
		
		respond_to do |format|
	  		format.js
    	end
	end
	  
  
	def page_params
	  params.require(:page).permit(:body, :id, :location, :old_location, :title, :page_type, :featured_person, 
	    membership_attributes: [:netid, :first_name, :last_name, :department, { department_list: [] }, :program, { program_list: [] }, :access, :email, :office_address, :office_phone, :lab_address, :lab_phone, :mail_address, :mail_code, :position_status, :title, :research_statement, :research_statement, :accepting_students, :picture, :research_area, { research_list: [] }, :lab_webpage, :personal_webpage],
	  	paths_attributes: [:categories_id, :id, :path, :tabs_id, :stylesheets_id, :welcomes_id, :title, :_destroy,
			group_paths_attributes: [ :group_id, :id, :path_id, :_destroy, 
				groups_attributes: [:id, :name]
			]
		]
	  )
	end
  
end

