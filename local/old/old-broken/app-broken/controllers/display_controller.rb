class DisplayController < ApplicationController
	
	def index
		
		@directory_info = Person.new
		
		@display_parameters = params
		
		if params[:school]
			@school = params[:school]
		else
			@school = ""
		end
	
		if params[:building] and params[:building] != "Morrill"
			building1 = "%"
		else
			building1 = "%Morrill%"
		end
	
		if params[:department] and params[:department] != ""
			dept1 = params[:department]
			dept2 = params[:department]+",%"
			dept3 = "% "+params[:department]
			dept4 = "% "+params[:department]+","
			@department = params[:department]
		else
			dept1 = "%"
			dept2 = "%"
			dept3 = "%"
			dept4 = "%"
			@department = ""
		end
		
		if params[:program] and params[:program] != ""
			prog1 = params[:program]
			prog2 = params[:program]+",%"
			prog3 = "% "+params[:program]
			prog4 = "% "+params[:program]+","
			@program = params[:program]
		else
			prog1 = "%"
			prog2 = "%"
			prog3 = "%"
			prog4 = "%"
			@program = ""
		end
		
		if params[:office_address] and params[:office_address] != ""
			office_address = "%" + params[:office_address] + "%"
			@office_address = params[:office_address]
		else
			office_address = "%"
			@office_address = ""
		end
	
		if params[:admin] and params[:admin] != "admin"
		
			if params[:school] and params[:school] == "ib"
			
				@people = Person.find( :all, :select => ["last_name, first_name, picture, title, department, program, position_status, office_address, lab_address"], :conditions => ["( (office_address LIKE :building1) or (lab_address LIKE :building1) ) and ( (department LIKE :dept1 or department LIKE :dept2 or department LIKE :dept3 or department LIKE :dept4 ) or (program LIKE :prog1 or program LIKE :prog2 or program LIKE :prog3 or program LIKE :prog4 ) ) and upper(position_status) NOT LIKE upper('Graduate%')", 
					{ :building1 => building1, :dept1 => dept1, :dept2 => dept2, :dept3 => dept3, :dept4 => dept4, :prog1 => prog1, :prog2 => prog2, :prog3 => prog3, :prog4 => prog4 }],
					:order => "last_name, first_name" )
		
			elsif params[:school] and params[:school] == "mcb"
			
				Person.establish_connection(
				  :adapter => "mysql2",
				  :encoding => "utf8",
				  :database => "mcb_production",
				  :username => "sib",
				  :password => "PbAbEnt",
				  :socket => "/var/run/mysqld/mysqld.sock"
				)
			
				@people = Person.find( :all, :select => ["last_name, first_name, picture_name as picture, titles as title, primary_department as department, primary_department as program, status as position_status, address_office as office_address, address_lab as lab_address"], :conditions => ["( (address_office LIKE :building1) or (address_lab LIKE :building1) ) and ( (primary_department LIKE :dept1 or primary_department LIKE :dept2 or primary_department LIKE :dept3 or primary_department LIKE :dept4 ) ) ", 
					{ :building1 => building1, :dept1 => dept1, :dept2 => dept2, :dept3 => dept3, :dept4 => dept4 }],
					:order => "last_name, first_name" )
					
				for person in @people
					if !person.picture.empty?
						person.picture = "http://mcb.illinois.edu/faculty_research/images/headshots/" + person.picture
					end
				end
	
				Person.establish_connection(
				  :adapter => "mysql2",
				  :encoding => "utf8",
				  :database => "sib_production",
				  :username => "sib",
				  :password => "PbAbEnt",
				  :socket => "/var/run/mysqld/mysqld.sock"
				)
				
			else
			
				@people = [ Person.find( :first, :select => ["last_name, first_name, picture, title, department, program, position_status, office_address, lab_address"] ) ]
			
			end
			
			
			
				
				
				
				
				
				
				
				
		end
		
	
		respond_to do |format|
			format.html
			format.js
		end
	
	end  # End index
	
end
