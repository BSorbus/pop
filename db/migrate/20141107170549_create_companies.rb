class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :short,                            limit: 10, null: false, default: ""
      t.string :name, index: true,                limit: 100, null: false, default: ""
      t.string :address_city, index: true,        limit: 50, null: false, default: ""
      t.string :address_street,                   limit: 50 
      t.string :address_house,                    limit: 10
      t.string :address_number,                   limit: 10 
      t.string :address_postal_code,              limit: 6
      t.text :address
      t.string :phone,                            limit: 50               
      t.string :email,                            limit: 50 
      t.string :nip,                              limit: 13 
      t.string :regon,                            limit: 9 
      t.string :pesel,                            limit: 11
      t.boolean :informal_group,                  null: false, default: false
      t.text :note
      t.references :user, index: true

      t.timestamps
    end
    add_foreign_key :companies, :users

    add_index :companies, [:short, :user_id],     unique: true
    #add_index :companies, [:name, :user_id],      unique: true
  end  
end
