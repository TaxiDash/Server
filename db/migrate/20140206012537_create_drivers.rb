class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :dob
      t.string :type_id
      t.string :address
      t.string :city, :default => "Nashville"
      t.string :state, :default => "TN"
      t.integer :zipcode
      t.string :race
      t.string :sex
      t.integer :height
      t.integer :weight
      t.string :license
      t.string :phone_number
      t.date :training_completion_date
      t.date :permit_expiration_date
      t.integer :permit_number
      t.string :status
      t.string :owner
      t.string :company_name
      t.date :physical_expiration_date
      t.boolean :valid, :default => true
      t.string :beacon_id
      t.decimal :average_rating, :default => 0
      t.integer :total_ratings, :default => 0

      t.timestamps
    end
  end
end
