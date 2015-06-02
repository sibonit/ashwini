class Admin::CoursesController < ApplicationController
  before_filter :authorize

  # Custom Methods
      
  # GET /admin/courses/special
  # GET /admin/courses/special.xml
  def special
    @courses = Course.find( :all, :select => "id, course_number, website, call_number, credit_hours, course_time, instructor, description", :conditions => ["special_topic"], :order => "course_number, course_title" )
	@other_courses = Course.find( :all, :select => "id, course_number, website, call_number, credit_hours, course_time, instructor, description", :conditions => ["NOT ( special_topic )"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /admin/courses/additional
  # GET /admin/courses/additional.xml
  def additional
    @courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section", :conditions => ["additional_approved_course"], :order => "course_number, course_title" )
	@other_courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section", :conditions => ["NOT ( additional_approved_course )"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /admin/courses/area
  # GET /admin/courses/area.xml
  def area
    @courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section, area3_requirement,  area1_course, area2_course, area3_course", :conditions => ["( area1_course OR area2_course OR area3_course )"], :order => "course_number, course_title" )
	@other_courses = Course.find( :all, :select => "id, course_number, website, course_title, credit_hours, offered, lab_section, area3_requirement", :conditions => ["NOT ( area1_course OR area2_course OR area3_course )"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end
  
 


  # GET admin/courses
  # GET admin/courses.xml
  def index
    @courses = Course.find( :all, :select => "id, course_number, website, course_number, cross_listings, course_title, credit_hours, offered, area1_course, area2_course, area3_course, additional_approved_course, lab_section, advanced_comp", :conditions => ["ib_course"], :order => "course_number, course_title" )
	@other_courses = Course.find( :all, :select => "id, course_number, website, course_number, cross_listings, course_title, credit_hours, offered, area1_course, area2_course, area3_course, additional_approved_course, lab_section, advanced_comp", :conditions => ["NOT ( ib_course )"], :order => "course_number, course_title" )

    respond_to do |format|
      format.html { render :layout => 'sib.html' }
      format.xml  { render :xml => @courses }
    end
  end

  # GET /admin/courses/1
  # GET /admin/courses/1.xml
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /admin/courses/new
  # GET /admin/courses/new.xml
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /admin/courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /admin/courses
  # POST /admin/courses.xml
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        flash[:notice] = 'Course was successfully created.'
        format.html { redirect_to( :action => 'show', :id => @course) }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new"  }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/courses/1
  # PUT /admin/courses/1.xml
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:notice] = 'Course was successfully updated.'
        format.html { redirect_to( :back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/courses/1
  # DELETE /admin/courses/1.xml
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to( :back ) }
      format.xml  { head :ok }
    end
  end



  protected

  def ssl_requirement?
    true
  end

end
