class AddComplaintToCars < ActiveRecord::Migration[5.0]
  def change
    add_column :cars, :complaint, :string, default: ""
  end
end
