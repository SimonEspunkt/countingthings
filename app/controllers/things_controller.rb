class ThingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_thing, only: [:show, :edit, :update, :destroy, :statistic]

  # GET /things
  # GET /things.json
  def index
    @things = current_user.things.all
  end

  ###DELTE
  def debug
    render plain: Thing.all.inspect
  end

  # GET /things/1
  # GET /things/1.json
  def show
    @users = @thing.users.select('users.id, email')

    #get statistics for user event tracking
    @userevents = @thing.events.group("user_id,strftime('%Y-%m-%d', created_at)").group("user_id").count()
  end

  def statistic
    if params[:format] == 'json'
      #only respond to json requests
      @users = @thing.users.select('users.id, email')
      @userevents = @thing.events
        .group("user_id")
        .group("user_id,strftime('%Y-%m-%d', created_at)")
        .count()

      daterange = Array.new
      @userevents.each_key do |key|
        daterange.push(key[0])
      end
      @daterange = daterange.minmax

    else
      #if request is not json
      redirect_to thing_path
    end
  end

  # GET /things/new
  def new
    @thing = current_user.things.new
  end

  # GET /things/1/edit
  def edit
  end

  # POST /things
  # POST /things.json
  def create
    @thing = current_user.things.build(thing_params)
    @thing.owner_id = current_user.id

    respond_to do |format|
      if current_user.things << @thing
        format.html { redirect_to things_path, notice: 'Thing was successfully created.' }
        format.json { render :show, status: :created, location: @thing }
      else
        format.html { render :new }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /things/1
  # PATCH/PUT /things/1.json
  def update
    authorize @thing
    respond_to do |format|
      if @thing.update(thing_params)
        format.html { redirect_to things_path, notice: 'Thing was successfully updated.' }
        format.json { render :show, status: :ok, location: @thing }
      else
        format.html { render :edit }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    authorize @thing
    @thing.destroy
    respond_to do |format|
      format.html { redirect_to things_url, notice: 'Thing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      @thing = current_user.things.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def thing_params
      params.require(:thing).permit(:name)
    end
end
