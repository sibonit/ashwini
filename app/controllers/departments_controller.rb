#KA: June 2015

class DepartmentsController < ApplicationController

  layout :choose_layout



def show
	#KA: Get the department id from the url (ex. url: http://dev.sib.illinois.edu/people/departments/5)
	@dept_id = params[:id]

	#KA: Get the department name for the id
	@dept_name = Department.find(@dept_id).name

	#KA: Join the 3 tables (People, departments, departments_people) to get the list for people for the department_id selected
	@people = Person.joins('inner join departments_people on (people.id=departments_people.person_id) inner join departments on (departments.id = departments_people.department_id) where people.position_status="faculty" and departments_people.department_id= ' + @dept_id + '').uniq

end



  private
    def department_params
      params.require(:department).permit(:name )
    end


  private

  def choose_layout
    'two_column'
  end



end
