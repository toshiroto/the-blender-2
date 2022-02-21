class WeeklyPaymentsController < ApplicationController
  def index
    @weekly_payments = policy_scope(WeeklyPayment)
    @loanee = Loanee.find(params[:loanee_id])
    past_payments = 0
    @loanee.weekly_payments.each do |payment|
      past_payments += payment.amount.to_f
    end
    @progress = past_payments/@loanee.total.to_f * 100
  end

  def new
    @loanee = Loanee.find(params[:loanee_id])
    @weekly_payment = WeeklyPayment.new
    authorize @weekly_payment
  end

  def create
    @loanee = Loanee.find(params[:loanee_id])
    @weekly_payment = WeeklyPayment.new(weekly_payment_params)
    @weekly_payment.loanee = @loanee
    authorize @weekly_payment
    if @weekly_payment.save
      redirect_to loanee_weekly_payments_path
    else
      render :new
    end
  end

  def edit
    @weekly_payment = WeeklyPayment.find(params[:id])
    @loanee = @weekly_payment.loanee
    authorize @weekly_payment
  end

  def update
    @weekly_payment = WeeklyPayment.find(params[:id])
    @loanee = Loanee.find(params[:loanee_id])
    @weekly_payment.update(weekly_payment_params)
    @weekly_payment.loanee = @loanee
    authorize @weekly_payment
    if @weekly_payment.save
      redirect_to loanee_weekly_payments_path()
    else
      render :edit
    end
  end

  private

  def weekly_payment_params
    params.require(:weekly_payment).permit(:loanee_id, :amount, :amount_cents)
  end
end
