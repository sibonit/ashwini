class GroupPath < ActiveRecord::Base
  has_one    :group
  has_one    :path
  belongs_to :group
  belongs_to :path
  
  accepts_nested_attributes_for :group
  accepts_nested_attributes_for :path
end
