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


class Rider < ActiveRecord::Base
  has_many :ratings
  has_many :rides

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

  def self.search(query)
	query = query.downcase
	p = "%#{query}%"
	where("uuid like ?", p)
  end

end
