class Document < ActiveRecord::Base
    belongs_to :driver
    has_attached_file :doc, 
        :path => ":rails_root/public/documents/:class/:id/:basename_:style.:extension",
        :url => "/documents/:class/:id/:basename_:style.:extension"

    validates_attachment :doc,
        :presence => true

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
