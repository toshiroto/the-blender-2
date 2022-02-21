class ChangeDefaultStatusInLoanees < ActiveRecord::Migration[6.0]
  def change
    change_column_default :loanees, :status, 0
  end
end
