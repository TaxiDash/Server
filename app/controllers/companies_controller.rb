#   Copyright 2014 Vanderbilt University
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


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

  # Get the top companies and their phone numbers
  # GET /mobile/companies/contact.json
  def contact_companies
    @companies = Company.all.to_a
    @companies.sort_by{ |c| -c.average_rating.round(5) }
  end

  # GET /companies/recalc/:id
  def recalculate_average
      # recalc either a specific one or all
      if params[:id] == "all"
          @companies = Company.all.to_a
      else
          @companies = [ Company.find(params[:id]) ]
      end
      @companies.each do |company|
          drivers = company.drivers.to_a

          company.total_ratings = 0
          company.average_rating = 0

          if drivers.count > 0 then
              drivers.each do |d|
                  if d.ratings.count != d.total_ratings or d.average_rating == 0 then
                      # Fix the driver's ratings
                      d.total_ratings = d.ratings.count
                      d.average_rating = 0

                      d.ratings.each do |r|
                          d.average_rating += r.rating
                      end
                      d.average_rating /= d.total_ratings
                      d.save

                  end
                  company.total_ratings += d.total_ratings
                  company.average_rating += d.average_rating * d.total_ratings
              end
              company.average_rating /= company.total_ratings
          end

          company.save
    
      end
      
      #Redirect
      if params[:id] == "all"
          redirect_to "/companies"
      else
          set_company
          redirect_to @company
      end
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
      params.require(:company).permit(:name, :phone_number, :logo)
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
