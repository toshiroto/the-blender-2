class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :loans # loan officer
  has_many :loanees, through: :loans
  has_many :debts, class_name: 'Loanee' # borrower
  has_one :loan_groups, through: :loanees, source: :loans
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def to_label
    full_name
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def active_debt
    debts.first
  end

  def percentage
    (get_payments_amount.to_f * 100 / get_total.to_f)
  end

  def payment_ratio
    # [['Task', 'Hours per Day'],
    [['Paid', get_payments_amount.to_f],
    ['Not paid', (get_total.to_f - get_payments_amount.to_f)]]
  end

  def payment_ratio_group
    # [['Task', 'Hours per Day'],
    [['Paid', get_payments_amount_group.to_f],
    ['Not paid', get_total_group.to_f - get_payments_amount_group.to_f]]
  end

  def weekly_payment_graph
    data_format = []
    unless active_debt.nil?
      debts.last.weekly_payments.each do |payment|
        data_format << [payment.created_at.strftime("%B %d %Y"), payment.amount.to_f]
      end
    else
      return data_format
    end
    return data_format
  end

  def get_payments_amount
    payments_amount = 0
    unless active_debt.nil?
      debts.last.weekly_payments.each do |payment|
        payments_amount += payment.amount.to_f
      end
    else
      return payments_amount
    end
    return payments_amount
  end

  def get_total
    unless active_debt.nil?
      debts.last.total.to_f
    else
      return 0
    end
  end

  def get_payments_amount_group
    payments_amount_group = 0
    unless active_debt.nil?
      debts.last.loan.loanees.each do |loanee|
        loanee.weekly_payments.each do |payment|
          payments_amount_group += payment.amount.to_f
        end
      end
    else
      return payments_amount_group
    end
    return payments_amount_group
  end

  def get_total_group
    total = 0
    unless active_debt.nil?
      debts.last.loan.loanees.each do |loanee|
        total += loanee.total.to_f
      end
    else
      return total
    end
    return total
  end

  def multiple_chart
    format_arr = []
    debts.last.loan.loanees.each do |loanee|
      data_arr = []
      loanee.weekly_payments.each do |payment|
        data_arr << ["#{payment.created_at.strftime("%B %d")}", payment.amount.to_f]
      end
      format_arr << {:name=>"#{loanee.user.first_name}", :data=>data_arr}
    end
    return format_arr

    #      return  [
    #   {:name=>"Golden State Warriors", :data=>[["2016-11-19T17:42:18.699Z", 0.6622516556291391], ["2016-11-20T07:56:55.662Z", 0.6622516556291391]]},
    #   {:name=>"Los Angeles Clippers", :data=>[["2016-11-19T17:42:18.795Z", 0.1], ["2016-11-20T07:56:55.717Z", 0.1]]}
    # ]
  end

  def get_weeklypayment
    debts.last.total.to_f / debts.last.loan.weeks
  end


  include PgSearch::Model
  pg_search_scope :loan_search,
    against: [ :first_name, :last_name, :email],
    using: {
      tsearch: { prefix: true }
    }
end
