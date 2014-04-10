class Company < ActiveRecord::Base
    has_many :drivers
    has_attached_file :logo, 
        :path => ":rails_root/public/images/:class/:id/:basename_:style.:extension",
        :url => "/images/:class/:id/:basename_:style.:extension",
        :default_style => :preview,
        :styles => {
            :thumb    => ['50x50^',  :jpg, :quality => 70],
            :preview  => ['300x300^',  :jpg, :quality => 70],
            :large    => ['600>',      :jpg, :quality => 70]
        }

    validates_attachment :logo,
        :presence => true,
        :size => { :in => 0..10.megabytes },
        :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }

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
                  Company.create! row.to_hash
                    end
    end

end
