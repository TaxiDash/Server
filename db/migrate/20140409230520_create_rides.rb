class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.integer :driver_id
      t.integer :rider_id
      t.float :start_latitude, :limit => 53, :null => true
      t.float :start_longitude, :limit => 53, :null => true
      t.float :end_latitude, :limit => 53, :null => true
      t.float :end_longitude, :limit => 53, :null => true
      t.decimal :estimated_fare
      t.decimal :actual_fare

      t.timestamps
    end
  end
end
