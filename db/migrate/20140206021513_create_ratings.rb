class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :driver_id
      t.string :rider_id
      t.integer :ride_id
      t.integer :rating
      t.string :comments
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
