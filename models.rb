class User < ActiveRecord::Base
	has_many :posts, dependent: :destroy

end

class Post <ActiveRecord::Base
	belongs_to :user
	validates_length_of :body, maximum:150
end