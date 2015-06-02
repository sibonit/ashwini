class Page < ActiveRecord::Base

	has_many :paths, :dependent => :destroy
	accepts_nested_attributes_for :paths, :allow_destroy => true
	
	belongs_to :featured_person, class_name: "Person", foreign_key: :featured_person_id
	
	attr_accessor :body
	attr_accessor :tab_options
	attr_accessor :category_options
	attr_accessor :stylesheet_options
	attr_accessor :welcome_options
	attr_accessor :old_location
	attr_accessor :current_path
	
	before_validation :strip_lead_slash
	before_validation :add_type
	before_save :publish
	
	before_destroy :delete_file
	
	validates :location, :uniqueness => true, :presence => true
	
	validates :paths, :length => { :minimum => 1 }
	
	def publish
		
		if page_type != 'Content'
			directoryname = 'app/views/static/' + page_type + '/' + File.dirname(location)
			filename = 'app/views/static/' + page_type + '/' + location
		else
			directoryname = 'app/views/static/' + File.dirname(location)
			filename = 'app/views/static/' + location
		end
		
			
		if !File.directory?( directoryname )
			FileUtils.mkdir_p( directoryname )
		end
			
		file = File.open(filename, 'w') # creates a new file and writes to it
			
		file.write body
		
		file.close # important, or no writing will happen
		
	
		if !old_location.blank? && (old_location != location)
			delete_file(old_location)
		end
			
		return true
		
	end
	
	def read
		if location
		
			
			if page_type != 'Content'
				filename = 'app/views/static/' + page_type + '/' + location
			else
				filename = 'app/views/static/' + location
			end
			
			file = File.new(filename) # creates a new file object
			
			self.body = file.read
			
			file.close # important, or no writing will happen
			
			
			return self.body
		else
			return "Main Content"
		end
		
	end
	
	def delete_file( deleted_file = location )
		
		if page_type != 'Content'
			filename = 'app/views/static/' + page_type + '/' + deleted_file
		else
			filename = 'app/views/static/' + deleted_file
		end
		
		
		if File.exist?(filename)
			
			File.delete(filename)
			
			return true
		else
			return false
		end
	end
	
	def strip_lead_slash
		paths.each do |path|
			if path.path =~ /^\/.*/
				path.path = path.path.from(1)
			end
		end
		
		if location =~ /^\/.*/
			location = location.to_s.from(1)
		end
	end
	
	def add_type
		if page_type != 'Content'
			paths.each do |path|
				if path.path =~ /^\/.*/
					if path.path !~ /^\/#{page_type}/
						path.path = page_type + path.path
					end
				else
					if path.path !~ /^#{page_type}/
						path.path = page_type + '/' + path.path
					end
				end
			end
			
			if location =~ /^\/.*/
				if location !~ /^\/#{page_type}/
					self.location = page_type + location.to_s
				end
			else
				if location !~ /^#{page_type}/
					self.location = page_type + '/' + location.to_s
				end
			end
		end	
	end
	
	def parse_types
		if page_type != 'Content'
			paths.each do |path|
				path.path = path.path.from(page_type.length)
			end
			
			self.location = location.to_s.from(page_type.length)
		end	
		
		paths.each do |path|
			if path.path =~ /^\/.*/
				path.path = path.path.from(1)
			end
		end
		
		if location =~ /^\/.*/
			self.location = location.to_s.from(1)
		end
	end
	
end
