class ContactsController < ApplicationController
  
  
#  def ssl_required?
#    true
#  end
  # example
  #ssl_required  :new, :create, :edit, :update, :destroy

  # Login Code
  # before_filter :admin, :except => [ :index, :new, :create, :update ]

  
  ### custom methods
  #def newindex
  #  @contacts = Contact.find( :all )
  #  render :action => 'newindex', :layout => 'newcontacts'
  #end
  
  def spreadsheet
	@header_info = Contact.new
	
	

    @contacts = Contact.find( :all )

	
    respond_to do |format|
      format.html 
    end
  end


  ### RESTful methods
  # GET /contacts
  # GET /contacts.xml
  def index
	@header_info = Contact.new
	
    @contacts = Contact.order( "id DESC, last_name, first_name" )
	
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
      format.csv  { render :action => 'spreadsheet.html', :layout => 'spreadsheet' }
    end
  end


  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
	
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Thanks for your Information!'
       #format.html { redirect_to( :action => 'index', :id => @contact) }
     	format.html { redirect_to( :action => 'new') }
	    format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])
	
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
       # format.html { redirect_to( :action => 'show', :id => @contact) }
	    format.html { redirect_to( :action => 'index' ) }
        format.xml  { head :ok }
		format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to( :back ) }
      format.xml  { head :ok }
    end
  end
  
	def contact_params
	  params.require(:contact).permit(:first_name, :last_name, :degree_type, :email, :emailed, :country, :zip_code, :area_code, :phone1, :phone2, :phone_ext)
	end
  
end

