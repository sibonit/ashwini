class Person < ActiveRecord::Base
	
	has_many :group_people
	has_many :groups, through: :group_people
	
	has_one :page, foreign_key: :featured_person_id

	accepts_nested_attributes_for :group_people, :allow_destroy => true


  def self.authorize?( netid )
    # check to see that netid is in people table
    person = Person.find_by_netid( netid )
    if person.nil?
      return false
    else
      true
    end
  end



  def self.admin?( netid )
    person = Person.joins(:groups).where("groups.name = 'Admin'").find_by_netid( netid )
    if person.nil?
      return false
    else
      true
    end
    if person.groups.where(:name => 'Admin')
      return true
    else
      return false
    end
  end
  
  def self.MSTOnline?( netid )
    person = Person.find_by_netid( netid )
    if person.nil?
      return false
    else
      true
    end
    if person.access.downcase.include? 'mstonline'
      return true
    else
      return false
    end
  end



  def self.initialize_ldap( netid, password )
    ldap = Net::LDAP.new
    ldap.host = 'ad.uiuc.edu'
    ldap.port = 636
    ldap.encryption( :simple_tls )
    ldap.auth( netid, password )
  
    ldap
  end
  


  def self.authenticate?( netid, password )
    return false if netid.nil? || password.nil?
    return false if netid.empty? || password.empty?
  
    treebase = 'OU=Campus Accounts,DC=ad,DC=uiuc,DC=edu'

    # bind with the server's credentials
    server_dn = "cn=app_rails,ou=life,dc=ad,dc=uiuc,dc=edu"
    server_password = 'zTayExT5'
    ldap = initialize_ldap( server_dn, server_password )
  
    # bind_as searches for account and re-binds
    result = ldap.bind_as(
      :base => treebase,
      :filter => "(cn=#{ netid })",
      :password => password
    )
  
    # bind_as will return false if re-binding failed
    # check that we only matched one record
    if result and result.length == 1
      #puts "Authenticated #{ result.first.dn }"
      return true
    else
      #puts "Authentication FAILED."
      return false
    end
  
  end






  def full_name
    [first_name, last_name].compact.join(" ")
  end
  
	def department_list
		if !department.nil?
			department.split(', ')
		else
			return ""
		end
	end
	
	
	def department_list=(dept)
		split = dept.split(', ')
		join = split.join(', ')
		self.department = join
	end

	def department_show
		if department.nil? 
		  shown = "" if department.nil? 
                  return shown
                end
		shown = department.gsub("10", "INHS-CAE")
		shown = shown.gsub("11", "INHS")
		shown = shown.gsub("12", "MIP")
		shown = shown.gsub("13", "Animal Sciences")
		shown = shown.gsub("14", "Crop Sciences")
		shown = shown.gsub("15", "Microbiology")
		shown = shown.gsub("16", "Biophysics")
		shown = shown.gsub("17", "IGB")
		shown = shown.gsub("18", "None")
		shown = shown.gsub("19", "Biochemistry")
		shown = shown.gsub("1", "Animal Biology")
		shown = shown.gsub("2", "Biology Library")
		shown = shown.gsub("3", "Cell and Developmental Biology")
		shown = shown.gsub("4", "Entomology")
		shown = shown.gsub("5", "Integrative Biology")
		shown = shown.gsub("7", "Molecular and Cellular Biology")
		shown = shown.gsub("8", "INHS-CBD")
		shown = shown.gsub("9", "NRES")
		shown = shown.gsub("0", "")
		shown.gsub("6", "Plant Biology")
	end

	def program_list
		if !program.nil?
			program.split(', ')
		else
			return ""
		end
	end
	
	
	def program_list=(prog)
		split = prog.split(', ')
		join = split.join(', ')
		self.program = join
	end

	def program_show
		if program.nil? 
		  shown = "" if program.nil? 
                  return shown
                end
		shown = program.gsub("10", "Cell and Developmental Biology")
		shown = shown.gsub("11", "Entomology")
		shown = shown.gsub("12", "Integrative Biology")
		shown = shown.gsub("13", "Molecular and Cellular Biology")
		shown = shown.gsub("14", "Plant Biology")
		shown = shown.gsub("1", "Biology")
		shown = shown.gsub("2", "PHD")
		shown = shown.gsub("3", "PEEC")
		shown = shown.gsub("4", "Masters in Biology")
		shown = shown.gsub("5", "PMPB")
		shown = shown.gsub("6", "NSP")
		shown = shown.gsub("7", "MST")
		shown = shown.gsub("8", "Animal Biology")
    	shown = shown.gsub("PSM", "PSM Program")
		shown = shown.gsub("0", "")
		shown.gsub("9", "Biology Library")
	end

	def list( l )
		if !l.nil?
			l.split(', ')
		else
			return ""
		end
	end
	
	def research_list
		if !research_area.nil?
			research_area.split(', ')
		else
			return ""
		end
	end
	
	
	def research_list=(res)
		split = res.split(', ')
		join = split.join(', ')
		self.research_area = join
	end
	
	def research_show
		if research_area.nil? 
		  shown = "" if research_area.nil? 
                  return shown
                end
		shown = research_area.gsub("1", "Physiology & Development")
		shown = shown.gsub("2", "Ecology")
		shown = shown.gsub("3", "Evolution & Systematics")
		shown = shown.gsub("4", "Behavior")
		shown.gsub("5", "Genetics & Biochemistry")
	end
								
								
	def directory_title
		shown = ""
		
		if department != "" and department != "0"
			shown = shown + self.department_show + " "
		end
		
		if program != "" and program != "11" and program != "14" and program != "8"
			shown = shown + self.program_show + " "
		end
		
		if research_area != ""
			if department != ""
				shown = shown + "- "
			end
			shown = shown + self.research_show + " "
		end
		
		if position_status != ""
			shown = shown + self.position_status + " "
		else
			shown = "All " + shown
		end
		
		
		if shown == ""
			shown = "All SIB Directory"
		else
			shown = shown + "Directory"
		end
		
		shown.split(/\s+/).each{ |word| word.capitalize! }.join(' ') 
		
	end

	def content_image
		shown = ""
		
		if department == "1"
			shown = shown + "Animal-"
		elsif department == "4"
			shown = shown + "Entomology-"
		elsif department == "6"
			shown = shown + "Plant-"
		elsif program == "3"
			shown = shown + "Peec-"
		elsif program == "5"
			shown = shown + "Pmpb-"
		else	
			shown = shown + "All-"
			if research_area == "1"
				return  shown + "Area1-Faculty"
			elsif research_area == "2"
				return  shown + "Area2-Faculty"
			elsif research_area == "3"
				return  shown + "Area3-Faculty"
			elsif research_area == "4"
				return  shown + "Area4-Faculty"
			elsif research_area == "5"
				return  shown + "Area5-Faculty"
			end			
		end
		
		if research_area == "1"
			shown = shown + "All-"
		elsif research_area == "2"
			shown = shown + "All-"
		elsif research_area == "3"
			shown = shown + "All-"
		elsif research_area == "4"
			shown = shown + "All-"
		elsif research_area == "5"
			shown = shown + "All-"
		else	
			shown = shown + "All-"
		end
		
		if position_status == "faculty"
			shown = shown + "Faculty"
		elsif position_status == "staff"
			shown = shown + "Staff"
		elsif position_status == "academic"
			shown = shown + "Academic"
		elsif position_status == "graduate"
			shown = shown + "Graduate"
		else 
			shown = shown + "All"
		end
		
		
		
		if program == "4"
			shown = "Masters"
		end
		
		return shown
		
	end
	
end
