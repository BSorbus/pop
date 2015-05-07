class RemoveAddressFromCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :address, :text
  end
end
