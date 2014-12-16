class ThingPolicy < ApplicationPolicy
	attr_reader :user, :thing

	def initialize(user, thing)
		@user = user
		@thing = thing
	end

	def user_is_owner?
		user.id == @thing.owner_id
	end

	def edit?
		update?
	end

	def update?
		user.admin? or user_is_owner?
	end

	def destroy?
		user.admin? or user_is_owner?
	end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
