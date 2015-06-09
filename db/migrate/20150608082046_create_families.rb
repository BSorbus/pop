class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :number,                                         null: false, default: ""
      t.string :proposal_number
      t.date :concluded,                                        null: false
      t.date :valid_from,                                       null: false
      t.date :applies_to
      t.string :pay,                                            null: false, default: "M"
      t.string :protection_variant,                             null: false
      t.decimal :assurance,  precision: 10, scale: 2,           null: false, default: 0.00
      t.decimal :assurance_component, precision: 15, scale: 2,  null: false, default: 0.00
      t.boolean :family_lock,                                   null: false, default: false
      t.text :note
      t.references :company, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :families, :companies
    add_foreign_key :families, :users

    add_index :families, [:number, :user_id],   unique: true
  end
end
