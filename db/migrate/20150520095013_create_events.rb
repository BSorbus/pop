class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.boolean :allday
      t.datetime :start_date
      t.datetime :end_date
      t.string :color
      t.string :url_action
      t.references :user, index: true

      t.timestamps
    end
  end
end 
