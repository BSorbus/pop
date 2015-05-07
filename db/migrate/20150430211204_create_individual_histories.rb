class CreateIndividualHistories < ActiveRecord::Migration
  def change
    create_table :individual_histories do |t|
      t.integer :individual_id, index: true
      t.string :last_name
      t.string :first_name
      t.string :address_city
      t.string :address_street 
      t.string :address_house
      t.string :address_number
      t.string :address_postal_code
      t.string :pesel
      t.date :birth_date
      t.string :profession
      t.text :note
      t.integer :user_id
      
      t.timestamps null: false
    end
  end
end
