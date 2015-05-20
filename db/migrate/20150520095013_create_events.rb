class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start
      t.datetime :end
      t.boolean :allday
      t.string :url_action
      t.references :user, index: true

      t.timestamps
    end
  end
end 
