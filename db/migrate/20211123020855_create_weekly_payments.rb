class CreateWeeklyPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_payments do |t|
      t.references :loanee, null: false, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
