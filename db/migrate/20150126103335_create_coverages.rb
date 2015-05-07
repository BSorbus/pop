class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      t.references :rotation, index: true
      t.references :group, index: true
      t.references :insured, index: true
      t.references :payer, index: true
      t.text :note

      t.timestamps null: false
    end
    add_foreign_key :coverages, :rotations
    add_foreign_key :coverages, :groups
    add_foreign_key :coverages, :individuals, column: :insured_id, primary_key: "id"
    add_foreign_key :coverages, :individuals, column: :payer_id, primary_key: "id"

    add_index :coverages, [:rotation_id, :insured_id, :payer_id],     unique: true
  end
end
