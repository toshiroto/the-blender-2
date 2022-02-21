class RemoveColumnsFromLoans < ActiveRecord::Migration[6.0]
  def change
    remove_column :loans, :due_by, :date
    remove_column :loans, :instalments, :float
    remove_column :loans, :start_date, :date
  end
end
