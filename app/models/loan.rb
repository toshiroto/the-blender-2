class Loan < ApplicationRecord
  belongs_to :user
  has_many :loanees, dependent: :destroy
  accepts_nested_attributes_for :loanees

  validates :weeks, presence: true

  def actual_amount_group
    actual_amount_group = 0
    self.loanees.each do |loanee|
      loanee.weekly_payments.each do |weekly_payment|
        if weekly_payment.created_at.strftime('%Y-%m-%d') == Date.today.strftime('%Y-%m-%d')
            actual_amount_group= actual_amount_group + weekly_payment.amount.to_f
        end
      end
    end
    actual_amount_group
  end

  def expected_amount_group
    expected_amount_group = 0
    self.loanees.each do |loanee|
      expected_amount_group += (loanee.total.to_f / self.weeks)
    end
    expected_amount_group.round(2)
  end

  def loan_total
    loan_total = 0
    loanees.each do |loanee|
      loan_total += loanee.total.to_f
    end
    loan_total.round(2)
  end

  def start_time
    start_date # Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end

  def self.get_today_payments(on_date = Date.today)
    loans_today = []
    Loan.all.each do |loan|
      i = 1
      loan.weeks.times do
        if ((loan.start_date) + (i * 7)) == on_date
          loans_today << loan
          i = i + 1
        end
      end
    end
    loans_today
  end

  def self.dates_to_loanee_count(loans)
    loans.each_with_object({}) do |loan, hash|
      i = 1
      loan.weeks.times do
        relevant_date = ((loan.start_date) + (i * 7))

        hash[relevant_date] ||= 0
        hash[relevant_date] += loan.loanees.count

        i = i + 1
        end
      end
  end

  def self.get_expected_amount(loans)
    amounts = {
    actual_amount_total: 0,
    expected_amount_total:  0,
    }
    loans.each do |loan|
      expected_amount_group = 0
      actual_amount_group = 0
      loan.loanees.each do |loanee|
          expected_amount_group =  expected_amount_group + (loanee.total.to_f / loan.weeks)
          loanee.weekly_payments.each do |weekly_payment|
          if weekly_payment.created_at.strftime('%Y-%m-%d') == Date.today.strftime('%Y-%m-%d')
              actual_amount_group += + weekly_payment.amount.to_f
          end
        end
      end
      amounts[:actual_amount_total]= amounts[:actual_amount_total] + actual_amount_group
      amounts[:expected_amount_total]= amounts[:expected_amount_total] + expected_amount_group
    end
    amounts
  end

  # def self.loanees_per_day(date)
  #   Loanee.joins(:loans).where(start_date: date).count
  # end

end
