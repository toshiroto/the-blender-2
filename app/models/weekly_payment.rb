class WeeklyPayment < ApplicationRecord
  belongs_to :loanee

  validates :amount, presence: true
  # monetize :amount_cents
  def amount_money
    Money.new(amount, :mxn)
  end
end
