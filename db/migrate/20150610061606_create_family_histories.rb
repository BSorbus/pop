class CreateFamilyHistories < ActiveRecord::Migration
  def change
    create_table :family_histories do |t|
      t.integer :family_id, index: true
      t.string :number
      t.string :proposal_number
      t.date :concluded
      t.date :valid_from
      t.date :applies_to
      t.string :pay
      t.string :protection_variant
      t.decimal :assurance, precision: 15, scale: 2
      t.decimal :assurance_component, precision: 15, scale: 2
      t.boolean :family_lock
      t.text :note
      t.integer :company_id
      t.integer :user_id

      t.timestamps null: false
    end
    #add_foreign_key :family_histories, :families
    #add_foreign_key :family_histories, :companies
    #add_foreign_key :family_histories, :users
  end
end
