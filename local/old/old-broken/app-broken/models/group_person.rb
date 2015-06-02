class GroupPerson < ActiveRecord::Base

  belongs_to :group
  belongs_to :person
  
  accepts_nested_attributes_for :group
  accepts_nested_attributes_for :person
end
