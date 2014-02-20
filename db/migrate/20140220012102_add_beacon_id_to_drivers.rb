class AddBeaconIdToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :beacon_id, :string
  end
end
