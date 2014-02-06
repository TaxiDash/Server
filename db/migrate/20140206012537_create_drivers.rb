class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :dob
      t.string :typeid
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :race
      t.string :sex
      t.integer :height
      t.integer :weight
      t.integer :license
      t.integer :phone_number
      t.date :training_completion_date
      t.date :permit_expiration_date
      t.integer :permit_number
      t.string :status
      t.string :owner
      t.string :company_name
      t.date :physical_expiration_date
      t.boolean :valid
      t.decimal :average_rating
      t.integer :total_ratings

      t.timestamps
    end
  end
end
