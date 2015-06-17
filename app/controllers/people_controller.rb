class PeopleController < ApplicationController

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
        redirect_to @person
    else
      render 'new'
    end
  end



  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
   	flash[:success] = "Profile updated"
      	redirect_to @person
          else
      render 'edit'
    end
  end


  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to people_url
  end



  private
    def person_params
      params.require(:person).permit(:last_name, :email, :netid )
    end


end
