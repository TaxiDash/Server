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


class Document < ActiveRecord::Base
    belongs_to :driver
    has_attached_file :doc, 
        :path => ":rails_root/public/documents/:class/:id/:basename_:style.:extension",
        :url => "/documents/:class/:id/:basename_:style.:extension"

    validates_attachment :doc,
        :presence => true,
        :content_type => { :content_type => ["image/jpeg", "image/png", "text/plain", "application/x-dvi", "application/msword", "application/pdf"] }

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
                  Document.create! row.to_hash
                    end
    end

	# search documents in the table
	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		dl = p
		df = p
		
		a = query.split
		ln = Driver.select('last_name').all.map(&:last_name)
		fn = Driver.select('first_name').all.map(&:first_name)
		ln.map!{|s| s.downcase}
		fn.map!{|s| s.downcase}	
		
		
		(fn.include?(a[0])) ? df = 1 + fn.find_index { |x| x == (a[0]) } : df = df
		(ln.include?(a[1])) ? dl = 1 + ln.find_index { |x| x == (a[1]) } : dl = dl
		
		where("driver_id like ? or driver_id like ? or title like ? or description like ?", df, dl, p, p)
	end
	
end
