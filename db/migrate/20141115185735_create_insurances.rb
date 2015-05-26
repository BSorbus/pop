class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.string :number,                           null: false, default: ""
      t.date :concluded,                          null: false
      t.date :valid_from,                         null: false
      t.date :applies_to
      t.string :pay,                              null: false, default: "R"
      t.boolean :insurance_lock,                  null: false, default: false
      t.text :note
      t.references :company, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_foreign_key :insurances, :users
    add_foreign_key :insurances, :companies

    add_index :insurances, [:number, :user_id],   unique: true
    add_index :insurances, [:concluded]
  end  
end
