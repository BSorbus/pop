class CreateInsuranceHistories < ActiveRecord::Migration
  def change
    create_table :insurance_histories do |t|
      t.integer :insurance_id, index: true
      t.string :number
      t.date :concluded
      t.date :valid_from
      t.date :applies_to
      t.string :pay
      t.boolean :insurance_lock
      t.text :note
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end  
end
