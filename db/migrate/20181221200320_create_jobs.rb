class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :mechanic
      t.string :car
      t.boolean :status
    end
  end
end
