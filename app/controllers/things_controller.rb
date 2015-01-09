class ThingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_thing, only: [:show, :edit, :update, :destroy, :statistic]
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  # GET /things
  # GET /things.json
  def index
    @things = current_user.things.all
  end


  # GET /things/1
  # GET /things/1.json
  def show
    @users = @thing.users.select('users.id, email')

    #get statistics for user event tracking
    numberOfDays = 30
    timerange = (Time.now - numberOfDays.to_i.days)..Time.now
    @userevents = @thing.events
        .where(created_at: timerange)
        .group("user_id")
        .group("user_id,DATE_FORMAT(created_at, '%Y-%m-%d')")
        .count()
  end


  #POST /things/:id/statistic.json
  def statistic
    if params[:format] == 'json'
      #only respond to json requests
      @users = @thing.users.select('users.id, email')

      case params[:type]
      when 'overall'
        getOverallStatistics
      when 'yearly'
        getYearlyStatistics
      when 'monthly'
        getMonthlyStatistics        
      when 'daily'
        getDailyStatistics  
      else
        redirect_to thing_path
      end

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

    #length parameter demermines the amount of days to look back from now
    #default is 30 days
    def getDailyStatistics
      if not params[:length].nil?
        numberOfDays = params[:length].to_i
      else
        numberOfDays = 30
      end

      timerange = (Time.now - numberOfDays.to_i.days)..Time.now

      @userevents = @thing.events
        .where(created_at: timerange)
        .group("user_id")
        .group("user_id,DATE_FORMAT(created_at, '%Y-%m-%d')")
        .count()
    end

    def getOverallStatistics
      @userevents = @thing.events
        .group("user_id")
        .count()
    end

    def getYearlyStatistics
      @userevents = @thing.events
        .group("user_id")
        .group("user_id,DATE_FORMAT(created_at, '%Y')")
        .count()

      #compute all years to include to cover all found events
      range = Array.new
      @userevents.each_key do |key|
        range.push(key[1])
      end
      range = range.minmax

      @datarange = Array.new
      (range[0]..range[1]).each do |year|
        @datarange.push(year)
      end
    end

    def getMonthlyStatistics
      if not params[:length].nil?
        numberOfMonths = params[:length].to_i
      else
        numberOfMonths = 12
      end

      timerange = (Time.now - numberOfMonths.to_i.months)..Time.now

      @userevents = @thing.events
        .where(created_at: timerange)
        .group("user_id")
        .group("user_id,DATE_FORMAT(created_at, '%Y-%m')")
        .count()
    end

    def invalid_record
      flash[:alert] = "Bitte überprüfe deine Eingaben."
      redirect_to(request.referrer || things_path)
    end
end
