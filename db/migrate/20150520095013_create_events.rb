class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.boolean :allday
      t.datetime :start_date, index: true
      t.datetime :end_date, index: true
      t.string :color
      t.string :url_action, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end 
