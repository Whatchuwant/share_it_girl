class User < ActiveRecord::Base
	has_one :profile
	
	  # users.password_hash in the database is a :string
  
  attr_accessor :password
  validates_confirmation_of :password
  before_save :encrypt_password

  def encrypt_password
  	self.password_salt = BCrypt::Engine.generate_salt
	self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end
 
  def self.authenticate(email, password)
	user = User.where(email: email).first
	if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
	user
	else
	nil
    end
  end
  
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