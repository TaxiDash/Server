class Rider < ActiveRecord::Base
  has_many :ratings

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
                  Rider.create! row.to_hash
          end
    end

	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		where("uuid like ?", p)
	end


end
