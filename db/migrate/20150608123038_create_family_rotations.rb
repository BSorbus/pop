class CreateFamilyRotations < ActiveRecord::Migration
  def change
    create_table :family_rotations do |t|
      t.date :rotation_date,                      null: false
      t.boolean :rotation_lock,                   null: false, default: false
      t.date :date_file_send
      t.text :note
      t.references :family, index: true

      t.timestamps null: false
    end
    add_foreign_key :family_rotations, :families

    add_index :family_rotations, [:rotation_date]
  end
end
