class PeopleController < ApplicationController
  
  
#  def ssl_required?
#    true
#  end
  # example
  #ssl_required  :new, :create, :edit, :update, :destroy

  # Login Code
  before_filter :admin, :except => [ :index ]

  
  ### custom methods
  
  
  def spreadsheet
	@header_info = Person.new
	
	if params[:department] and params[:department] != ""
		dept1 = params[:department]
		dept2 = params[:department]+",%"
		dept3 = "% "+params[:department]
		dept4 = "% "+params[:department]+","
		@header_info.department = params[:department]
	else
		dept1 = "%"
		dept2 = "%"
		dept3 = "%"
		dept4 = "%"
		@header_info.department = ""
	end
	
	if params[:program] and params[:program] != ""
		prog1 = params[:program]
		prog2 = params[:program]+",%"
		prog3 = "% "+params[:program]
		prog4 = "% "+params[:program]+","
		@header_info.program = params[:program]
	else
		prog1 = "%"
		prog2 = "%"
		prog3 = "%"
		prog4 = "%"
		@header_info.program = ""
	end
	
	if params[:position_status]
		status = "%"+params[:position_status]+"%"
		@header_info.position_status = params[:position_status]
	else
		status = "%"
		@header_info.position_status = ""
	end
	
	if params[:research_area]
		research = "%"+params[:research_area]+"%"
		@header_info.research_area = params[:research_area]
	else
		research = "%"
		@header_info.research_area = ""
	end
	
	if params[:accepting_students]
		accepting = "%"+params[:accepting_students]+"%"
		@header_info.accepting_students = params[:accepting_students]
	else
		accepting = "%"
		@header_info.accepting_students = ""
	end
	
	if params[:hidden]
		hidden = params[:hidden]
		@header_info.hidden = params[:hidden]
	else
		hidden = 0
		@header_info.hidden = 0
	end


    @people = Person.where( ["( (department LIKE :dept1 or department LIKE :dept2 or department LIKE :dept3 or department LIKE :dept4 ) or (program LIKE :prog1 or program LIKE :prog2 or program LIKE :prog3 or program LIKE :prog4 ) ) and upper(position_status) LIKE upper(:status)
			and research_area LIKE :research and upper(accepting_students) LIKE upper(:accepting) and upper(hidden) LIKE upper(:hidden)", 
			{ :dept1 => dept1, :dept2 => dept2, :dept3 => dept3, :dept4 => dept4, :prog1 => prog1, :prog2 => prog2, :prog3 => prog3, :prog4 => prog4, :status => status, :research => research, :accepting => accepting, :hidden => hidden }] ).order("last_name, first_name" )

	
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @people }
      format.csv  { render :action => 'spreadsheet.csv', :layout => false }
    end
  end


  ### RESTful methods
  # GET /people
  # GET /people.xml
  def index
	@header_info = Person.new
	
	if params[:department] and params[:department] != ""
		dept1 = params[:department]
		dept2 = params[:department]+",%"
		dept3 = "% "+params[:department]
		dept4 = "% "+params[:department]+","
		@header_info.department = params[:department]
	else
		dept1 = "%"
		dept2 = "%"
		dept3 = "%"
		dept4 = "%"
		@header_info.department = ""
	end
	
	if params[:program] and params[:program] != ""
		prog1 = params[:program]
		prog2 = params[:program]+",%"
		prog3 = "% "+params[:program]
		prog4 = "% "+params[:program]+","
		@header_info.program = params[:program]
	else
		prog1 = "%"
		prog2 = "%"
		prog3 = "%"
		prog4 = "%"
		@header_info.program = ""
	end
	
	if params[:position_status]
		status = "%"+params[:position_status]+"%"
		@header_info.position_status = params[:position_status]
	else
		status = "%"
		@header_info.position_status = ""
	end
	
	if params[:research_area]
		research = "%"+params[:research_area]+"%"
		@header_info.research_area = params[:research_area]
	else
		research = "%"
		@header_info.research_area = ""
	end
	
	if params[:accepting_students]
		accepting = "%"+params[:accepting_students]+"%"
		@header_info.accepting_students = params[:accepting_students]
	else
		accepting = "%"
		@header_info.accepting_students = ""
	end
	
	if params[:hidden]
		hidden = params[:hidden]
		@header_info.hidden = params[:hidden]
	else
		hidden = 0
		@header_info.hidden = 0
	end

	
    @people = Person.where( ["( (department LIKE :dept1 or department LIKE :dept2 or department LIKE :dept3 or department LIKE :dept4 ) or (program LIKE :prog1 or program LIKE :prog2 or program LIKE :prog3 or program LIKE :prog4 ) ) and upper(position_status) LIKE upper(:status)
			and research_area LIKE :research and upper(accepting_students) LIKE upper(:accepting) and upper(hidden) LIKE upper(:hidden)", 
			{ :dept1 => dept1, :dept2 => dept2, :dept3 => dept3, :dept4 => dept4, :prog1 => prog1, :prog2 => prog2, :prog3 => prog3, :prog4 => prog4, :status => status, :research => research, :accepting => accepting, :hidden => hidden }] ).order("last_name, first_name" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
      format.csv  { render :action => 'spreadsheet.html', :layout => 'spreadsheet' }
    end
  end


  # GET /people/1
  # GET /people/1.xml
  def show
  	if Person.where(netid: params[:id]).length > 0
		@person = Person.where(netid: params[:id]).take
	else
    	@person = Person.find(params[:id])
	end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
	@person.research_area = '6'
	@person.program = '1'
	@person.department = '18'
	@person.position_status = 'Academic'
	

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
  	if Person.where(netid: params[:id]).length > 0
		@person = Person.where(netid: params[:id]).take
	else
    	@person = Person.find(params[:id])
	end
	
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to( :action => 'show', :id => @person) }
     #format.html { redirect_to( :action => 'index') }
	    format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
	
    respond_to do |format|
      if @person.update_attributes(person_params)
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to( :action => 'show', :id => @person) }
	  #  format.html { redirect_to( :action => 'index' ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
	deleted_person = @person.full_name
    @person.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: "#{deleted_person} was deleted." }
      format.xml  { head :ok }
    end
  end
  
  private
  
	def person_params
	  params.require(:person).permit(:netid, :first_name, :last_name, :department, { department_list: [] }, :program, { program_list: [] }, :access, :email, :office_address, :office_phone, :lab_address, :lab_phone, :mail_address, :mail_code, :position_status, :title, :research_statement, :research_statement, :accepting_students, :picture, :research_area, { research_list: [] }, :lab_webpage, :personal_webpage)
	end
  
end

