class RemoveCarsDiagnosisAndStatus < ActiveRecord::Migration[5.0]
  def change
    remove_column :cars, :status
    remove_column :cars, :diagnosis
  end
end
