class RemoveAddressFromIndividual < ActiveRecord::Migration
  def change
    remove_column :individuals, :address, :text
  end
end
