class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.attachment :logo
      t.string :phone_number
      t.decimal :average_rating, :default => 0
      t.integer :total_ratings, :default => 0

      t.timestamps
    end

    add_index :companies, :name, :unique => true
  end
end
