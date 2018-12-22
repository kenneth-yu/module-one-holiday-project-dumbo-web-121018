class RenameCarsCustomer < ActiveRecord::Migration[5.0]
  def change
    rename_column :cars, :customer, :customer_id
  end
end
