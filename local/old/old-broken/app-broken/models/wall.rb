class Wall < ActiveRecord::Base
	has_many :comments, -> { order("id DESC") }, dependent: :destroy
end
