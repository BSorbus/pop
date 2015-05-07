class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.string :category
      t.string :description
      t.string :quotation
      t.boolean :tariff_fixed
      t.boolean :full_range
      t.string  :risk_group
      t.string :pay
      t.boolean :informal_group
      t.integer :condition_int
      t.string :condition_str
      t.decimal :tariff_percent, precision: 10, scale: 2
      t.decimal :tariff_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
