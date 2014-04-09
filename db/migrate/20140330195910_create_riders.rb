class CreateRiders < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.string :uuid

      t.timestamps
    end
    add_index :riders, :uuid, :unique => true
  end
end
