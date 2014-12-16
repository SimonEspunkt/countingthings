class User < ActiveRecord::Base
	#define roles for authorization
	enum role: [:user, :admin]
	after_initialize :set_default_role, :if => :new_record?

	def set_default_role
		self.role ||= :user
	end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #associations
  has_many :userobjects
  has_many :things, :through => :userobjects
end
