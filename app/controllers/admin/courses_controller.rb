#KA: JUne 2015

class Admin::CoursesController < ApplicationController


def index
    @courses = Course.all

end

def show
   @course = Course.find(params[:id])
end

def new
   @course = Course.new
end

def edit
    @course = Course.find(params[:id])
end


def create
    @course = Course.new(course_params)
    if @course.save
	flash[:success] = "New Course created"
        redirect_to admin_courses_path(@course)
    else
      render 'new'
    end
  end



  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
   	flash[:success] = "Course updated"
      	redirect_to admin_courses_path(@course)
          else
      render 'edit'
    end
  end


  def destroy
    Course.find(params[:id]).destroy
    flash[:success] = "Course deleted"
    redirect_to admin_courses_url
  end






  private
    def course_params
      params.require(:course).permit(	:title, :description, :subject_code, :course_number, :hours, :crosslist, :lab,
					:advanced, :spring, :fall, :summer, :url, :note, :document_file_name, :document_content_type, 
					:document_file_size, :document_updated_at, :online, :ib_area, :odd_years_only, :even_years_only,
					:honors_only, :merit_program)
    end




end

