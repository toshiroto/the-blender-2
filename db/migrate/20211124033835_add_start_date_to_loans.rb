class AddStartDateToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :start_date, :date
    remove_column :loans, :status, :integer
  end
end
