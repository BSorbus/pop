class CreateRotationHistories < ActiveRecord::Migration
  def change
    create_table :rotation_histories do |t|
      t.integer :rotation_id, index: true
      t.date :rotation_date
      t.boolean :rotation_lock
      t.date :date_file_send
      t.text :note
      t.integer :insurance_id

      t.timestamps
    end
  end  
end
