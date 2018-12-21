class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.integer :year
      t.string :customer
      t.string :diagnosis
      t.string :status 
    end
  end
end
