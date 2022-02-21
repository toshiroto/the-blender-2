class AddColumnsToLoanees < ActiveRecord::Migration[6.0]
  def change
    add_column :loanees, :status, :integer
  end
end
