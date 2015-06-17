class Person < ActiveRecord::Base

  has_and_belongs_to_many :departments
  has_and_belongs_to_many :research_areas

  # Paperclip
  has_attached_file :photo, 
                    :default_url => "/images/default/no_photo.png", 
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }
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

		
      
end
