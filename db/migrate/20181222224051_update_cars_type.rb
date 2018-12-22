class UpdateCarsType < ActiveRecord::Migration[5.0]
  def change
    change_column :cars, :customer_id, :integer
  end
end
