class CreateCompanyHistories < ActiveRecord::Migration
  def change
    create_table :company_histories do |t|
      t.integer :company_id, index: true
      t.string :short
      t.string :name
      t.string :address_city
      t.string :address_street
      t.string :address_house
      t.string :address_number
      t.string :address_postal_code
      t.string :phone
      t.string :email
      t.string :nip
      t.string :regon
      t.string :pesel
      t.boolean :informal_group
      t.text :note
      t.integer :user_id

      t.timestamps null: false
    end
    #add_foreign_key :company_histories, :companies
  end
end
