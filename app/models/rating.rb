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
		dl = p
		df = p
		r = p
		a = query.split
		rn = Rider.select('uuid').all.map(&:uuid)
		ln = Driver.select('last_name').all.map(&:last_name)
		fn = Driver.select('first_name').all.map(&:first_name)
		rn.map!{|s| s.downcase}
		ln.map!{|s| s.downcase}
		fn.map!{|s| s.downcase}	
		
		(rn.include?(query)) ? r = 1 + rn.find_index { |x| x == (query) } : r = r
		(fn.include?(a[0])) ? df = 1 + fn.find_index { |x| x == (a[0]) } : df = df
		(ln.include?(a[1])) ? dl = 1 + ln.find_index { |x| x == (a[1]) } : dl = dl
		
		where("driver_id like ? or driver_id like ? rider_id like ? or rating like ? or timestamp like ? or comment like ?", df, dl, rn, p, p, p)
	end

end
