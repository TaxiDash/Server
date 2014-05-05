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
				
		where("driver_id like ? or title like ? or description like ?", p, p, p)
	end
	
end
