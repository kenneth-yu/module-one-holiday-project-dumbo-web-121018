class UpdateJobsBooleanDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :jobs, :status, :boolean, default: false
  end
end
