class Document < ActiveRecord::Base
    belongs_to :driver
    has_attached_file :doc, 
        :path => ":rails_root/public/documents/:class/:id/:basename_:style.:extension",
        :url => "/documents/:class/:id/:basename_:style.:extension"

    validates_attachment :doc,
        :presence => true,
        :content_type => { :content_type => ["text/plain", "application/x-dvi", "application/msword", "application/pdf"] }

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


end
