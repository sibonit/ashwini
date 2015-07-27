class Course < ActiveRecord::Base

  # validations
  validates :subject_code, presence: true
  validates :course_number, presence: true
  validates :note, length: { maximum: 255 }
  validates :title, length: { maximum: 255 }
  validates :subject_code, length: { maximum: 255 }
  validates :ib_area, length: { maximum: 255 }
  validates :url, length: { maximum: 255 }

  # Paperclip
  has_attached_file :document
  validates_attachment_content_type :document, :content_type => [ "application/pdf" ]
 




 
end
