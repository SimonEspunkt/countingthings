class ThingPolicy < ApplicationPolicy
	attr_reader :user, :thing

	def initialize(user, thing)
		@user = user
		@thing = thing
	end

	def owner?
		user.id == @thing.owner_id
	end

	def destroy?
		user.admin? or owner?
	end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
