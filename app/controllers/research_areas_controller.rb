
#KA: June 2015


class ResearchAreasController < ApplicationController



  layout :choose_layout



def show
	#KA: Get the department id from the url (ex. url: http://dev.sib.illinois.edu/people/departments/5)
	@res_area_id = params[:id]

	#KA: Get the department name for the id
	@res_area_name = ResearchArea.find(@res_area_id).name

	@res_area_id_non_peec = ResearchArea.where(peec: 0).pluck(:id)

	#KA: Join the 3 tables (People, departments, departments_people) to get the list for people for the department_id selected
	@people = Person.joins('inner join people_research_areas on (people.id=people_research_areas.person_id) inner join research_areas on (research_areas.id = people_research_areas.research_area_id) where people.position_status="faculty" and people_research_areas.research_area_id= ' + @res_area_id + '').uniq

end



  private
    def research_area_params
      params.require(:research_area).permit(:name )
    end


  private

  def choose_layout
    'two_column'
  end





end
