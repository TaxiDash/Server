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
		
		where("driver_id like ? or driver_id like ? or rider_id like ? or start_latitude like ? or start_longitude like ? or end_latitude like ? or end_longitude like ? or estimated_fare like ? or actual_fare like ?", dl, df, r, p, p, p, p, p, p)
	end
end
