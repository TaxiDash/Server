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


class Driver < ActiveRecord::Base
    has_many :ratings
    has_many :documents
    belongs_to :company
    has_attached_file :avatar, 
        :path => ":rails_root/public/images/:class/:id/:basename_:style.:extension",
        :url => "/images/:class/:id/:basename_:style.:extension",
        :default_style => :thumb,
        :styles => {
            :thumb    => ['100x100^',  :jpg, :quality => 70],
            :preview  => ['300x300^',  :jpg, :quality => 70],
            :large    => ['600>',      :jpg, :quality => 70]
        }

    validates_attachment :avatar,
        :presence => true,
        :size => { :in => 0..10.megabytes },
        :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }

    #Required fields
    validates :first_name, :last_name, :zipcode, :date_of_birth, :address, :city, :state, :license, :phone_number, :type_id, :race, :sex, :height, :weight, :training_completion_date, :permit_expiration_date, :permit_number, :vehicle_owner, :company_id, :physical_expiration_date, :beacon_id,
        presence: true

    #Regex expressions defining valid input
    LETTERS_ONLY = /[a-zA-Z ]*/
    NUMBERS_ONLY = /[\d]*/
    LETTERS_AND_NUMBERS = /[a-zA-Z\d]*/

    #Possible type options to be stored in the database
    #Add more types by modifying the following statement to
    # TYPE_OPTIONS = /(type1|type2|type3|type4)/
    # where type1, type2... are replaced with the acceptable
    # names of the different types. The number of types is 
    # flexible and can be any number of options
    TYPE_OPTIONS = /(taxi|wrecker)/
    SEX_OPTIONS = /(male|female)/

    # Uncomment the following when status options are known
    # STATUS_OPTIONS = /(status1|status2)/

    # Length validations
    #validates :license, format: { with: Regexp.new('\A' + NUMBERS_ONLY.source + '\z'), 
                                 #message: 'must be a valid type.' }, length: { is: 9, message: 'must be 9 digits long.' }
    validates :phone_number, format: { with: Regexp.new('\A' + NUMBERS_ONLY.source + '\z'), 
                                       length: { is: 10, message: 'must be 10 digits long.' }}
    validates :zipcode, length: { is: 5, message: 'must be 5 digits long.' }
    validates :beacon_id, format: { with: Regexp.new('\A' + LETTERS_AND_NUMBERS.source + '\z'), 
                                 message: 'must be a valid type.' }, uniqueness: true
    # validates :permit_number, length: { is: 5, message: 'Permit must be 5 digits long.'  }

    # LETTERS_ONLY validations
    validates :city, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }
    validates :race, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }

    # For now, the owner will be letters only. Later this may be adjusted to be more specific
    validates :vehicle_owner, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }

    # Specific input validations
    #validates :type_id, format: { with: Regexp.new('\A' + TYPE_OPTIONS.source + '\z'), 
                                 #message: 'must be a valid type.' }
    validates :sex, format: { with: Regexp.new('\A' + SEX_OPTIONS.source + '\z'), 
                                 message: 'must be a valid type.' }
    #validates :status, format: { with: Regexp.new('\A' + STATUS_OPTIONS.source + '\z'), 
    #                             message: 'Status must be a valid type.' }
    
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
                  Driver.create! row.to_hash
		  end
    end

	# search drivers in the table
	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		c = p
		v = p
		a = Company.select('name').all.map(&:name)
		a.map!{|s| s.downcase}
				
		(a.include?(query)) ? c = 1 + a.find_index { |x| x == (query) } : c = c
		
		query == "valid" ? v = (query == "valid") : v = v
		query == "invalid" ? v = (query == "valid") : v = v
		
	   	where("last_name like ? or first_name like ? or middle_name like ? or type_id like ?or company_id like ? or permit_expiration_date like ? or valid like ? or beacon_id like ? or permit_number like ?", p, p, p, p, c, p, v, p, p)
	end
	
	
	def self.advanced_search(query)
		name = query[0].downcase
		name = name.split
		
		f_name = name[0]
		l_name = f_name
		op = "OR"

		if name.length >= 2
			l_name = name[name.length - 1]
			op = "AND"
			
		end
		
		f_name = "%#{f_name}%"
		l_name = "%#{l_name}%"

		license = query[1]
		license = "%#{license}%"
		
		permit = query[2]
		permit = "%#{permit}%"
		
		v = (query[4] == "1")
		
		beacon = query[5]
		beacon = "%#{beacon}%"
		
		
		min_rating = query[6]
		max_rating = query[7]
		
		where("(first_name LIKE ? " + op + " last_name LIKE ?) AND license LIKE ? AND permit_number LIKE ? AND beacon_id LIKE ? AND valid LIKE ? AND average_rating >= ? AND average_rating <= ?", f_name, l_name, license, permit, beacon, v, min_rating, max_rating)
	end
end
