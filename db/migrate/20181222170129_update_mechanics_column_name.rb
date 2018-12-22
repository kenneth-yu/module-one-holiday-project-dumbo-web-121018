class UpdateMechanicsColumnName < ActiveRecord::Migration[5.0]
  def change
      rename_column :mechanics, :manager, :manager_id
  end
end
