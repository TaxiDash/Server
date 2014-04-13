class RidesController < ApplicationController
  before_action :set_ride, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /rides
  # GET /rides.json
  def index
    @rides = Ride.all
  end

  # GET /rides/1
  # GET /rides/1.json
  def show
  end

  # Download CSV
  def download
      @rides = Ride.all
      puts "Sending data as csv..."
      send_data @rides.as_csv, :filename => "rides.csv"
  end

  # Import CSV
  def import
      Ride.import(params[:file])
      redirect_to root_url, notice: "Rides imported."
  end

  # GET /rides/new
  def new
    @ride = Ride.new
  end

  # GET /rides/1/edit
  def edit
  end

  # POST /rides
  # POST /rides.json
  def create
    @ride = Ride.new(ride_params)

    # Get/Create a rider by the uuid (sent under "rider_id")
    # This works only if the uuid is strictly numeric
    @rider = Rider.where(:uuid => @ride.rider_id).first

    if @rider.nil?
      @rider = Rider.new(:uuid => @ride.rider_id)
      @rider.save
    end

    @ride.rider_id = @rider.id

    respond_to do |format|
      if @ride.save
        format.html { redirect_to @ride, notice: 'Ride was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ride }
      else
        format.html { render action: 'new' }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rides/1
  # PATCH/PUT /rides/1.json
  def update
    respond_to do |format|
      if @ride.update(ride_params)
        format.html { redirect_to @ride, notice: 'Ride was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @ride }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride.destroy
    respond_to do |format|
      format.html { redirect_to rides_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_params
      params.require(:ride).permit(:driver_id, :rider_id, :start_latitude, :start_longitude, :end_latitude, :end_longitude, :estimated_fare, :actual_fare)
    end

    def sort_column
   	  Ride.column_names.include?(params[:sort]) ? params[:sort] : "driver.first_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
	
end
