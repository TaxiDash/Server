class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  
  # GET /companies
  # GET /companies.json
  def index
  	if params[:search]
  		@companies = Company.search(params[:search]).order("name asc")
  	elsif params[:sort] == "drivers.length"
  		if sort_direction == "asc"
  			@companies = Company.joins(:drivers).group("drivers.company_id").order("count(drivers.company_id) asc")
  		else
  			@companies = Company.joins(:drivers).group("drivers.company_id").order("count(drivers.company_id) desc")
  		end
  	else
	    @companies = params[:sort] == nil ? Company.all : Company.order(sort_column + " " + sort_direction)
	end
	@companies = @companies.page(params[:page])
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # Download CSV
  def download
      @companies = Company.all
      puts "Sending data as csv..."
      send_data @companies.as_csv, :filename => "companies.csv"
  end

  # Import CSV
  def import
      Company.import(params[:file])
      redirect_to root_url, notice: "Companies imported."
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render action: 'show', status: :created, location: @company }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @company }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /companies/recalc/:id
  def recalculate_average
      set_company
      drivers = @company.drivers.all

      drivers.each do |d|
          if d.ratings.count != d.total_ratings then
              # Fix the driver's ratings
              d.total_ratings = d.ratings.count
              d.average_rating = 0

              d.ratings.each do |r|
                  d.average_rating += r.rating
              end
              d.average_rating /= d.total_ratings

          end
          @company.total_ratings += d.total_ratings
          @company.average_rating += d.average_rating * d.total_ratings
      end
      @company.average_rating /= @company.total_ratings

      redirect_to @company
  end

  # GET /mobile/images/companies/:id
  def get_image
    @company = Company.find(params[:id])
    if !@company.nil?
        puts "Getting the image for " << @company.name
        File.open(@company.logo.path, 'rb') do |f|
          send_data f.read, :type => @company.logo.content_type, :filename => @company.name, :disposition => "inline"
        end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  def search
  	@companies = Company.search(params[:search])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :logo)
    end
    
    def sort_column
    	if params[:sort] == "drivers.length"
    		"drivers.length"
    	else
    		Company.column_names.include?(params[:sort]) ? params[:sort] : "name"
    	end
    end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end
