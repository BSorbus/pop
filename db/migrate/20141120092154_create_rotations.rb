class CreateRotations < ActiveRecord::Migration
  def change
    create_table :rotations do |t|
      t.date :rotation_date,                      null: false
      t.boolean :rotation_lock,                   null: false, default: false
      t.date :date_file_send
      t.text :note
      t.references :insurance, index: true

      t.timestamps
    end
    add_foreign_key :rotations, :insurances

    add_index :rotations, [:rotation_date]
  end  
end
