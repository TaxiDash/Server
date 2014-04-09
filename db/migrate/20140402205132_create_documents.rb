class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :driver_id
      t.attachment :doc
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
