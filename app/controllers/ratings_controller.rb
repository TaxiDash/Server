class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.all
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end

  # Download CSV
  def download
      @ratings = Document.all
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
      # TODO Prevent fraud entries
puts "CREATE" 
    @rating = Rating.new(rating_params)

    # Adjust the given driver's meta data
    @driver = @rating.driver 
    @driver.average_rating = (@driver.average_rating * @driver.total_ratings + @rating.rating)/(@driver.total_ratings + 1)
    @driver.total_ratings +=  1
    @driver.save

    respond_to do |format|
      if @rating.save
        format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rating }
      else
        format.html { render action: 'new' }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
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
      params.require(:rating).permit(:driver_id, :rating, :comments, :timestamp)
    end
end
