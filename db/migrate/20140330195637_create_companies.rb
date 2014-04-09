class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.attachment :logo

      t.timestamps
    end

    add_index :companies, :name, :unique => true
  end
end
