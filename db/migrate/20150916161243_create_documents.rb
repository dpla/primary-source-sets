class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :source_id
      t.string :mime_type
      t.string :file_base
      t.timestamps null: false
    end
  end
end
