class UpdateMechanicsManagerType < ActiveRecord::Migration[5.0]
  def change
    change_column :mechanics, :manager, :integer
  end
end
