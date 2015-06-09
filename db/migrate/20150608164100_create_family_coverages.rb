class CreateFamilyCoverages < ActiveRecord::Migration
  def change
    create_table :family_coverages do |t|
      t.references :family_rotation, index: true
      t.references :insured, index: true
      t.references :payer, index: true
      t.text :note

      t.timestamps null: false
    end
    add_foreign_key :family_coverages, :family_rotations
    add_foreign_key :family_coverages, :individuals, column: :insured_id, primary_key: "id"
    add_foreign_key :family_coverages, :individuals, column: :payer_id, primary_key: "id"

    add_index :family_coverages, [:family_rotation_id, :insured_id, :payer_id], unique: true, name: 'index_family_coverages_on_family_rotation_insured_payer'
  end
end
