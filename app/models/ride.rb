class Ride < ActiveRecord::Base
  belongs_to :driver
  belongs_to :rider
  belongs_to :rating

  # Export as CSV 
  #
  def self.as_csv
      CSV.generate do |csv|
          csv << column_names
          all.each do |item|
              csv << item.attributes.values_at(*column_names)
          end
      end
  end

    def self.import(file)
          CSV.foreach(file.path, headers: true) do |row|
                  Ride.create! row.to_hash
          end
    end
    
    def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		where("driver_id like ? or rating_id like ? or rider_id like ? or start_latitude like ? or start_longitude like ? or end_latitude like ? or end_longitude like ? or estimated_fare like ? or actual_fare like ?", p, p, p, p, p, p, p, p, p)
	end
end
