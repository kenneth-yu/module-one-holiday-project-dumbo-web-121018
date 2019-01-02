class UpdateCarsQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :cars, :in_queue, :boolean, default: true
  end
end
