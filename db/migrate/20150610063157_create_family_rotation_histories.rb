class CreateFamilyRotationHistories < ActiveRecord::Migration
  def change
    create_table :family_rotation_histories do |t|
      t.integer :family_rotation_id, index: true
      t.date :rotation_date
      t.boolean :rotation_lock
      t.date :date_file_send
      t.text :note
      t.integer :family_id

      t.timestamps null: false
    end
  end
end
