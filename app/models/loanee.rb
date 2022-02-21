class Loanee < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_many :weekly_payments, dependent: :destroy

  validates :total, presence: true
  validates :status, presence: true

  enum status: { active: 0, closed: 1, late: 2, defaulted: 3 }
  monetize :total_cents
end
