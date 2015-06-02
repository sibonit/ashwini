class Path < ActiveRecord::Base
	belongs_to :page
	
	belongs_to :tab_group, class_name: "Group", foreign_key: :tabs_id
	belongs_to :category_group, class_name: "Group", foreign_key: :categories_id
	belongs_to :welcome_group, class_name: "Group", foreign_key: :welcomes_id
	belongs_to :stylesheet_group, class_name: "Group", foreign_key: :stylesheets_id
	
	accepts_nested_attributes_for :tab_group
	accepts_nested_attributes_for :category_group
	accepts_nested_attributes_for :welcome_group
	
	
	
	has_many :group_paths
	accepts_nested_attributes_for :group_paths, :allow_destroy => true
	
	has_many :groups, through: :group_paths
	accepts_nested_attributes_for :groups
	
	
	
	
	validates :path, :uniqueness => true, :presence => true
	
	
	
	def clone_with_associations
		new_path = self.dup
		#new_path.save
		#simple association
		new_path.groups = self.groups
		#two-level association 
		#self.bars.each do |bar|
		#  new_bar = bar.clone
		#  new_bar.save
		#  new_bar.chickens = bar.chickens 
		#  new_blerg.bars << bar
		#end
		new_path
	end
	
end
