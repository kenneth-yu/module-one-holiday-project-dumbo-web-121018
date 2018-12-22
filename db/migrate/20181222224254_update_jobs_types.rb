class UpdateJobsTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :jobs, :mechanic_id, :integer
    change_column :jobs, :car_id, :integer
  end
end
