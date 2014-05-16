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


class Company < ActiveRecord::Base
    has_many :drivers
    has_attached_file :logo, 
        :path => ":rails_root/public/images/:class/:id/:basename_:style.:extension",
        :url => "/images/:class/:id/:basename_:style.:extension",
        :default_style => :thumb,
        :styles => {
            :thumb    => ['50x50^',  :jpg, :quality => 70],
            :preview  => ['300x300^',  :jpg, :quality => 70],
            :large    => ['600>',      :jpg, :quality => 70]
        }

    validates_attachment :logo,
        :presence => true,
        :size => { :in => 0..10.megabytes },
        :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }

    NUMBERS_ONLY = /[\d]*/
    validates :phone_number, format: { with: Regexp.new('\A' + NUMBERS_ONLY.source + '\z'), 
                                       length: { is: 10, message: 'must be 10 digits long.' }}

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
                  self.create! row.to_hash
                    end
    end

	# search companies in the table
	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		where("name like ? or id like ?", p, p)
	end

end
