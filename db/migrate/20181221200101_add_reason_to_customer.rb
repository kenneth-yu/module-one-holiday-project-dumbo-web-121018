class AddReasonToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :reason, :string
  end
end
