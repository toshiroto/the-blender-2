class CreateLoanees < ActiveRecord::Migration[6.0]
  def change
    create_table :loanees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :loan, null: false, foreign_key: true
      t.float :total

      t.timestamps
    end
  end
end
