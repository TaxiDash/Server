class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
                  User.create! row.to_hash
          end
    end

	# search users in the table
	def self.search(query)
		query = query.downcase
		p = "%#{query}%"
		where("last_name like ? or first_name like ? or username like ? or email like ? or last_sign_in_at like ?", p, p, p, p, p)
	end
	

end
