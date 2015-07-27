class Admin::PeopleController < ApplicationController



def index
    @people = Person.all

end

def show
   @person = Person.find(params[:id])
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

    #KA: parameters to update in the table based on the selections in the research area checkbox
     @person.research_area_ids=params[:person][:research_area_ids]


    #KA: parameters to update in the table based on the selections in the departments checkbox
     @person.department_ids=params[:person][:department_ids]

 
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



 def set_dept
   @dept = Department.find(params[:id])
 end


    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :position_status, :netid, :middle_name, 
					:nickname, :primary_department, :titles, :education, :awards, :address_mail,
					:address_office, :address_lab, :mail_code, :phone_office, :phone_lab, :phone_fax,
					:url_cv, :url_lab, :url_pubs, :show_profile, :show_in_ib_directory, :show_in_peec_directory,  
					:show_in_peec_conservation_directory,  :show_in_peec_ecology_directory,  :show_in_peec_evolution_directory,
					:url_video, :url_external_profile, :auth, :profile_header, :profile_blurb, :publications_blurb, 
					:photo_file_name, :photo_content_type, :photo_file_size, :faculty_390_490 )
    end








end
