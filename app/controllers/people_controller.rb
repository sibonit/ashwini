# KA:June 2015: 

class PeopleController < ApplicationController

  #Select the 2 column layout
  layout :choose_layout

def index
	#KA: Search criteria defined in /model/person.rb
	if params[:search_by_name]
		@people = Person.search(params[:search_by_name]).order("last_name ASC")
	else
	       @people = Person.all
	end
end



#KA: Filter the search based on the page that's requested (Faculty, staff, academic etc)
def show
 	if params[:id] == "faculty"
	    @title = "Faculty"
	#KA: Get and show Department names and Research Areas
	#	@dept = Department.all.order("name ASC")
		@dept = Department.where("name IN(?)", ['Animal Biology', 'Entomology', 'Plant Biology'])
	#	@res_area = ResearchArea.all.order("name ASC")
 		@res_area_non_peec = ResearchArea.where(peec: 0).order("name ASC")

	elsif params[:id] == "faculty_all"
		@title = "Faculty"
		 @people = Person.where(position_status: 'faculty').order("last_name ASC")
	elsif params[:id] == "staff"
		@title = "Staff"
		 @people = Person.where(position_status: 'staff').order("last_name ASC")
	elsif params[:id] == "academic"
		@title = "Academic Professionals"
		 @people = Person.where(position_status: 'academic').order("last_name ASC")
	elsif params[:id] == "graduate_students"
		@title = "Graduate Students"
		 @people = Person.where(position_status: 'graduate student').order("last_name ASC")
	elsif params[:id] == "faculty_390_490"
		@title = "IB 390/IB 490 Faculty"
		@description = "Please note, this is a list of faculty that have historically accepted undergraduates into their labs for IB 390 or 490 credit.  This list does NOT indicate that faculty currently have openings in their labs.  Students must contact faculty individually to learn about potential openings in the lab."
		 @people = Person.where(faculty_390_490: 1).order("last_name ASC")
	elsif params[:id] == "all"
		@title = "All People"
		 @people = Person.all.order("last_name ASC")
	 else
	      @person = Person.find(params[:id])
	end


end


def new
   @person = Person.new
end

def edit
    @person = Person.find(params[:id])
end


def create
    @person = Person.new(person_params)
    if @person.save
	flash[:success] = "New Person created"
        redirect_to admin_people_path(@person)
    else
      render 'new'
    end
  end



  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
   	flash[:success] = "Profile updated"
      	redirect_to admin_people_path(@person)
          else
      render 'edit'
    end
  end


  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to admin_people_url
  end



  private
    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :position_status, :netid, :middle_name, 
					:nickname, :primary_department, :titles, :education, :awards, :address_mail,
					:address_office, :address_lab, :mail_code, :phone_office, :phone_lab, :phone_fax,
					:url_cv, :url_lab, :url_pubs, :show_profile, :show_in_ib_directory, :show_in_peec_directory,  
					:show_in_peec_conservation_directory,  :show_in_peec_ecology_directory,  :show_in_peec_evolution_directory,
					:url_video, :url_external_profile, :auth, :profile_header, :profile_blurb, :publications_blurb, 
					:photo_file_name, :photo_content_type, :photo_file_size )
    end




  private

  def choose_layout
    'two_column'
  end






end
