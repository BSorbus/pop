class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :category,                                       null: false, default: ''
      t.string :description
      t.decimal :discount_increase,   precision: 10, scale: 2,  null: false, default: 0.00
      t.references :group, index: true

      t.timestamps
    end
    add_foreign_key :discounts, :groups
  end
end
