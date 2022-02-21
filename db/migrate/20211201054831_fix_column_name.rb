class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :loanees, :total, :total_cents
    # rename_column :weekly_payments, :amount, :amount_cents
  end
end
