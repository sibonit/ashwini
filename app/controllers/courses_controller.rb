# KA:June 2015: 

class CoursesController < ApplicationController


  layout :choose_layout

def index
 #   @courses = Course.all

#KA: Only Undergaraduate courses  	
    @courses= Course.where("course_number NOT LIKE ?" , "#{5}%")

end


def show

   if params[:id] == "level_100"
	@title = "100-Level Courses"
        @courses= Course.where("course_number LIKE ?" , "#{1}%").order("course_number ASC")
   elsif params[:id] == "level_200"
	@title = "200-Level Courses"
	@courses= Course.where("course_number LIKE ?" , "#{2}%").order("course_number ASC")
   elsif params[:id] == "level_300"
	@title = "300-Level Courses"
	@courses= Course.where("course_number LIKE ?" , "#{3}%").order("course_number ASC")
   elsif params[:id] == "level_400"
	@title = "400-Level Courses"
	@courses= Course.where("course_number LIKE ?" , "#{4}%").order("course_number ASC")
   elsif params[:id] == "graduate"
	@title = "Graduate Courses"
	@courses= Course.where("course_number LIKE ? OR course_number LIKE ?" , "#{4}%", "#{5}%").order("course_number ASC")
   elsif params[:id] == "advanced"
	@title = "Advanced Courses"
	@courses= Course.where("advanced= 1").order("course_number ASC")
   elsif params[:id] == "additional_advanced"
	@title = "Additional Advanced Courses"
	@courses= Course.where("ib_area= 'AA'").order("course_number ASC")
   elsif params[:id] == "area"
	@title = "Advanced Courses by Area"
   elsif params[:id] == "semester"
	@title = "Advanced Courses by Semester"
  elsif params[:id] == "all"
	@title = "All Courses"
	@courses= Course.all

    else
  	 @course = Course.find(params[:id])
  end
end


  private
    def course_params
      params.require(:course).permit(	:title, :description, :subject_code, :course_number, :hours, :crosslist, :lab,
					:advanced, :spring, :fall, :summer, :url, :note, :document_file_name, :document_content_type, 
					:document_file_size, :document_updated_at, :online, :ib_area, :odd_years_only, :even_years_only,
					:honors_only, :merit_program)
    end




  private

  def choose_layout
    'two_column'
  end




end
