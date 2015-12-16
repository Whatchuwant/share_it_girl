class User < ActiveRecord::Base
	has_one :profile
	
	  # users.password_hash in the database is a :string

end

class Post < ActiveRecord::Base
# reference to table must be singular, even if table name is plural
	belongs_to :profile
end

class Profile < ActiveRecord::Base
	belongs_to :user
	has_many :posts
	has_many :follows, foreign_key: :followee_id, class_name: "::Follow"
	has_many :followings, foreign_key: :follower_id, class_name: "::Follow"
	has_many :followers, through: :follows, class_name: Profile
	has_many :followees, through: :followings, class_name: Profile
end

#when we want to see 

class Follow < ActiveRecord::Base
	 belongs_to :follower, foreign_key: :follower_id, class_name: Profile
	 belongs_to :followee, foreign_key: :followee_id, class_name: Profile
end