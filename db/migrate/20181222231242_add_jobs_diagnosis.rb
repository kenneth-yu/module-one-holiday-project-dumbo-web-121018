class AddJobsDiagnosis < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :diagnosis, :string
  end
end
