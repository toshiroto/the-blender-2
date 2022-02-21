class MonetizeWeeklyPayment < ActiveRecord::Migration[6.0]
  def change
    add_monetize :weekly_payments, :amount, currency: { present: false }
  end
end
