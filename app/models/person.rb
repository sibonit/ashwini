class Person < ActiveRecord::Base

  has_many :departments_people
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :research_areas


  # Paperclip
  #KA:18 June 2015: Exclamation character at the end of image size(60x80!), will ignore aspect ratio and make all images the same size.  
  has_attached_file :photo, 
                    :default_url => "/images/default/no_photo.png",		   
                    :styles => { :medium => "300>x300", :thumb => "60x80!" }
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

#KA: Add validations
  before_save { self.email = email.downcase }		#replace all uppercase chars to downcase before saving to DB

  #Last Name
  validates :last_name, presence: true, length: { maximum: 50 }
  #Email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i		# Check to see if there are only valid chars
  #validates :email, presence: true, length: { maximum: 255 },
  #                  format: { with: VALID_EMAIL_REGEX },
  #                  uniqueness: { case_sensitive: false }
  #NetID
  #validates :netid, presence: true, length: { maximum: 8 }

	


#KA: Search person by name (used in /people/index.html.erb)
def self.search(search_by_name)
	where("last_name like ? OR first_name like ?", "%#{search_by_name}%", "%#{search_by_name}%") 
end




  ### instance methods
  def full_name
    full_name = first_name
    full_name += " \"#{ nickname }\"" unless nickname.blank?
    full_name += " #{ middle_name }" unless middle_name.blank?
    full_name += " #{ last_name }" unless last_name.blank?
  end


  def last_first_name
    name = last_name
    name += ", " + first_name unless first_name.blank?
    name
  end
 
end
