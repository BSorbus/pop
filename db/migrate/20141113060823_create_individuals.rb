class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.string :last_name, index: true,           limit: 80, null: false, default: ""
      t.string :first_name, index: true,          limit: 30, null: false, default: ""
      t.string :address_city, index: true,        limit: 50, null: false, default: ""
      t.string :address_street,                   limit: 50 
      t.string :address_house,                    limit: 10
      t.string :address_number,                   limit: 10
      t.string :address_postal_code,              limit: 6
      t.text :address
      t.string :pesel, index: true,               limit: 11
      t.date :birth_date
      t.string :profession,                       limit: 50
      t.text :note
      t.references :user, index: true

      t.timestamps
    end
    add_foreign_key :individuals, :users

  end  
end
