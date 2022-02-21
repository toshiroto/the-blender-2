class LoansController < ApplicationController
before_action :set_loan, only: [ :show ]
  def index
    @date = params[:loans] && params[:loans][:on_date].present? ? Date.parse(params[:loans][:on_date]) : Date.today
    @loans = policy_scope(Loan)
    @dates_hash = Loan.dates_to_loanee_count(@loans)
    @weekly_payments = WeeklyPayment.all
    @loans_today = Loan.get_today_payments(@date)
    @amounts = Loan.get_expected_amount(@loans_today)
  end

  def show
    @progress =0
    @loan_total = 0
    @loan.loanees.each do |loanee|
      loanee.weekly_payments.each do |payment|
        @progress = @progress + payment.amount.to_f
      end
      @loan_total = @loan_total + loanee.total.to_f
    end
    @percentage = (@progress/@loan_total)*100
  end

  def new
    @loan = Loan.new
    3.times do
      @loan.loanees.build
    end
    authorize @loan
  end

  def create
    @loan = Loan.new(loan_params)
    @loan.user = current_user
    authorize @loan
    if @loan.save
      redirect_to loan_path(@loan)
    else
      render :new
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
    authorize @loan
  end

  def loan_params
    params.require(:loan).permit(:weeks, :start_date, loanees_attributes: [ :user_id, :total, :status])
  end
end
