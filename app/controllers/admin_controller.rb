class AdminController < ApplicationController

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
	flash[:success] = "Creating new people"
        #redirect_to @person
	redirect_to admin_url(@person)

    else
      render 'new'
    end
  end



  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
   	flash[:success] = "Profile updated"
      	#redirect_to @person
	redirect_to admin_url(@person)

          else
      render 'edit'
    end
  end


  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to admin_url(@person)
  end



  private
    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :position_status, :netid )
    end


end
