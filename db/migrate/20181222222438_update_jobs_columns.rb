class UpdateJobsColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :jobs, :car, :car_id
    rename_column :jobs, :mechanic, :mechanic_id
  end
end
