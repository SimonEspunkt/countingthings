class EventsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :set_thing, only: [:create, :destroy, :show]


	# DELETE /things/2/events
	# DELETE /things/2/events.json
  def destroy
  	@event = @thing.events.where(user_id: current_user.id).last
  	unless @event.nil?
	  	@event.destroy
	  	respond_to do |format|
	      format.html { redirect_to things_url, notice: 'Event successfully destroyed.' }
	      format.json { head :no_content }
	    end
	  else
	  	respond_to do |format|
	      format.html { redirect_to things_url, notice: 'No event to destroy found.' }
	      format.json { head :no_content }
	    end
  	end
  end

  # POST /things/2/events
  # POST /things/2/events.json
  def create
  	@event = @thing.events.new(user_id: current_user.id)

  	respond_to do |format|
      if @thing.events << @event
        format.html { redirect_to things_path, notice: 'Event successfully logged.' }
        format.json { render :show, status: :created, location: @thing }
      else
        format.html { render :new }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private
  	def set_thing
  		@thing = current_user.things.find(params[:thing_id])
  	end

end
