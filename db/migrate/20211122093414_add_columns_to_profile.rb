class AddColumnsToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :village, :string
    add_column :profiles, :phone_number, :string
    add_column :profiles, :birthday, :date
    add_column :profiles, :join_date, :date
    add_column :profiles, :business_type, :string
    add_reference :profiles, :user, null: false, foreign_key: true
  end
end
