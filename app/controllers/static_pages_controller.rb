class StaticPagesController < ApplicationController

  def overview
    @drivers = {}
    @companies = {}
    
  end

  def get_ratings
      length = params[:length].to_i || 5 #Entries to return
      sort_dir = params[:sort_dir] || "best" #Entries to return

      drivers = Driver.all.index_by(&:id)
      companies = Company.all.index_by(&:id)
      @drivers = {}
      @companies = {}

      drivers.each do |key, d| 
         d.total_ratings = 0
         d.average_rating = 0
      end

      companies.each do |k, c| 
         c.total_ratings = 0
         c.average_rating = 0
      end

      #Get the relevant ratings based on time
      puts "time is #{params[:time]}"
      case params[:time]
      when "month"
        @ratings = Rating.where(:created_at => 1.month.ago..Time.now)
      when "day"
        @ratings = Rating.where(:created_at => 1.day.ago..Time.now)
      when "week"
        @ratings = Rating.where(:created_at => 1.week.ago..Time.now)
      when "all"
        @ratings = Rating.all
      end

      @ratings = @ratings.to_a

      @ratings.each do |r| 
          # Store drivers/companies with any ratings in the interval
          if @drivers[r.driver_id].nil?
            @drivers[r.driver_id] = drivers[r.driver_id]
          end

          @drivers[r.driver_id].average_rating += r.rating
          @drivers[r.driver_id].total_ratings += 1

          # Now the companies
          c_id = @drivers[r.driver_id].company_id
          if @companies[c_id].nil?
            @companies[c_id] = companies[c_id]
          end

          @companies[c_id].average_rating += r.rating
          @companies[c_id].total_ratings += 1
      end

      # Get the averages
      @drivers.each{ |k, d| d.average_rating /= d.total_ratings }
      @companies.each{ |k, c| c.average_rating /= c.total_ratings }

      # Convert to a sorted array
      @drivers = @drivers.values.sort_by{ |d| -d.average_rating }
      @companies = @companies.values.sort_by{ |c| -c.average_rating }

      if sort_dir == "worst"
          @drivers.reverse!
          @companies.reverse!
      end

      # Get the desired number
      @drivers = @drivers[0..length-1]
      @companies = @companies[0..length-1]
  end

  def companies_rating(time)
  end

  def import_export
    authorize! :import_export, Driver
    authorize! :import_export, Company
    authorize! :import_export, Rider
  end
  
end
