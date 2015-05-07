class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :number,                                          null: false, default: 0
      t.string :quotation,                                        null: false, default: 'A'
      t.boolean :tariff_fixed,                                    null: false, default: false
      t.boolean :full_range,                                      null: false, default: false
      t.string :risk_group,                                       null: false, default: 'A'
      t.decimal :assurance,             precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :assurance_component,   precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :treatment,             precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :treatment_component,   precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :ambulatory,            precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :ambulatory_component,  precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :hospital,              precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :hospital_component,    precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :infarct,               precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :infarct_component,     precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :inability,             precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :inability_component,   precision: 10, scale: 2,  null: false, default: 0.00
      t.boolean :death_100_percent,                               null: false, default: false
      t.decimal :sum_component,         precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :sum_after_discounts,   precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :sum_after_increases,   precision: 10, scale: 2,  null: false, default: 0.00
      t.decimal :sum_after_monthly,     precision: 10, scale: 2,  null: false, default: 0.00
      t.references :insurance, index: true

      t.timestamps
    end
    add_foreign_key :groups, :insurances

    #add_index :groups, [:insurance_id, :quotation, :tariff_fixed, :full_range, :risk_group, :assurance, :treatment, :ambulatory, :hospital, :infarct, :inability, :death_100_percent],     unique: true
  end
end
