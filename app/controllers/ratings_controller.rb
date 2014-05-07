class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /ratings
  # GET /ratings.json
  def index
  	if params[:search]
  		@ratings = Rating.search(params[:search]).order("driver_id asc")
  	else
	    @ratings = params[:sort] == nil ? Rating.all : Rating.order(sort_column + " " + sort_direction)
	end
    @ratings = @ratings.page(params[:page])
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end

  # Download CSV
  def download
      @ratings = Rating.all
      puts "Sending data as csv..."
      send_data @ratings.as_csv, :filename => "ratings.csv"
  end

  # Import CSV
  def import
      Rating.import(params[:file])
      redirect_to root_url, notice: "Ratings imported."
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1/edit
  def edit
  end

  # POST /ratings
  # POST /ratings.json
  def create
    # Prevent fraud entries
    puts "Creating a rating" 
    @rating = Rating.new(rating_params)

    # Get/Create a rider by the uuid (sent under "rider_id")
    # This works only if the uuid is strictly numeric
    @rider = Rider.where(:uuid => @rating.rider_id).first

    if @rider.nil?
      @rider = Rider.new(:uuid => @rating.rider_id)
      @rider.save
    end

    @rating.rider_id = @rider.id

    # Create the ride if provided
    if not ride_params[:start_latitude].nil?
        puts "RIDE PARAMS: #{ride_params}"
        ride = Ride.new(ride_params)
        ride.rider_id = @rider.id
        ride.save
    end

    # Check the amount of recent ratings 
    if @rating.rider.ratings.where(:created_at => 24.hours.ago..Time.now).to_a.length < 11 #10 ratings per day

      # Adjust the given driver's meta data
      @driver = @rating.driver 
      @driver.average_rating = (@driver.average_rating * @driver.total_ratings + @rating.rating)/(@driver.total_ratings + 1)
      @driver.total_ratings +=  1
      @driver.save

      # Adjust the given company's meta data
      @company = @driver.company
      @company.average_rating = (@company.average_rating * @company.total_ratings + @rating.rating)/(@company.total_ratings + 1)
      @company.total_ratings +=  1
      @company.save

      # Link rating to ride
      @rating.ride_id = ride.nil? ? nil : ride.id

      respond_to do |format|
        if @rating.save
          format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
          format.json { render action: 'show', status: :created, location: @rating }
          if not ride.nil?
            ride.rating_id = @rating.id
            ride.save
          end
        else
          format.html { render action: 'new' }
          format.json { render json: @rating.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render action: 'new', notice: 'Too many recent ratings.' }
        format.json { render json: { :error => "Too many recent requests" }, status: :unprocessable_entity }
      end
      puts "Too many ratings. I suspect fraud."
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @rating }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rating
    puts "Setting @rating to " << params[:id]
    @rating = Rating.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rating_params
    params.require(:rating).permit(:driver_id, :rider_id, :ride_id, :rating, :comments, :timestamp)
  end

  def ride_params
    params.permit(:driver_id, :rider_id, :timestamp, :ride,
      :start_latitude, :start_longitude, :end_latitude, :end_longitude, :estimated_fare, :actual_fare) # ride params
  end

  def sort_column
    	Rating.column_names.include?(params[:sort]) ? params[:sort] : "driver_id"
  end

  def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
