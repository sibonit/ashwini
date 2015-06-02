class Group < ActiveRecord::Base
	has_many :group_paths
	has_many :paths, through: :group_paths
	
	accepts_nested_attributes_for :group_paths, :allow_destroy => true
	
	
	has_many :group_people
	has_many :people, through: :group_people
	
	accepts_nested_attributes_for :group_people, :allow_destroy => true
	accepts_nested_attributes_for :people
	
	
	belongs_to :tab_path, class_name: "Path", foreign_key: :tabs_id
	belongs_to :category_path, class_name: "Path", foreign_key: :categories_id
	belongs_to :welcome_path, class_name: "Path", foreign_key: :welcomes_id
	
	accepts_nested_attributes_for :tab_path
	accepts_nested_attributes_for :category_path
	accepts_nested_attributes_for :welcome_path
	
	
	validates :name, :uniqueness => true, :presence => true
	
end
