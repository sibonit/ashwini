class CoursesController < ApplicationController  
  
  def ssl_required?
    true
  end
  # example
  #ssl_required  :new, :create, :edit, :update, :destroy

  # Login Code
  before_filter :admin, :except => [ :index, :show, :special, :additional, :area ]

  # Custom Methods
      
  # GET /courses/special
  # GET /courses/special.xml
  def special
    @courses = Course.find( :all, :select => "id, course_number, website, call_number, credit_hours, course_time, instructor, description", :conditions => ["special_topic"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /courses/additional
  # GET /courses/additional.xml
  def additional
    @courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section", :conditions => ["additional_approved_course"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /courses/area
  # GET /courses/area.xml
  def area
    @courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section, area3_requirement,  area1_course, area2_course, area3_course", :conditions => ["( area1_course OR area2_course OR area3_course )"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
 


  # GET /courses
  # GET /courses.xml
  def index
    @courses = Course.find( :all, :select => "id, course_number, website, course_number, cross_listings, course_title, credit_hours, offered, area1_course, area2_course, area3_course, additional_approved_course, lab_section, advanced_comp, offered_note, offered_year, online_section", :conditions => ["ib_course"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def update
    @course = Course.find(params[:id])
	
    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:notice] = 'Course was successfully updated.'
       # format.html { redirect_to( :action => 'show', :id => @course) }
	    format.html { redirect_to( :action => 'index' ) }
		format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
		format.js
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end
end
