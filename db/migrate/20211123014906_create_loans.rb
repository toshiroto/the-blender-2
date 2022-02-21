class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :due_by
      t.float :instalments
      t.date :start_date
      t.integer :status
      t.integer :weeks

      t.timestamps
    end
  end
end
