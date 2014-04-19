class Rating < ActiveRecord::Base
    belongs_to :driver
    belongs_to :rider
    belongs_to :ride
    validates :rating, format: { with: /[12345]/, 
                                 message: 'Must be integer 1-5' }
    COMMENT_FORMAT = /[a-zA-Z. !?\d,#$'"()]*/
    validates :comments, length: { maximum: 250 ,
                                   message: 'must be 250 characters or fewer.' },
					     format: { with: Regexp.new('\A' + COMMENT_FORMAT.source + '\z'), 
										   message: 'Contains invalid characters' }
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
                  Rating.create! row.to_hash
          end
    end

	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		where("driver_id like ? or rider_id like ? or rating like ? or timestamp like ? or comment like ?", p, p, p, p, p)
	end

end
