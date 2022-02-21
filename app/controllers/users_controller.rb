class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def index
    if params[:query].present?
      @users = policy_scope(User).loan_search(params[:query])
    else
      @users = User.all
      @users = policy_scope(User)
    end
  end

  def new
    @user = User.new
    @user.build_profile
    authorize @user
  end

  def show
    @payments_amount = @user.get_payments_amount
    @total = @user.get_total
    @data = [@payments, @total]
  end

  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      redirect_to profiles_path
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, profile_attributes: [:village, :phone_number, :birthday, :join_date, :business_type, :birthday, :photo])
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  # def get_payments_amount(user)
  #   payments_amount = 0
  #   unless user.active_debt.nil?
  #     user.active_debt.weekly_payments.each do |payment|
  #       payments_amount += payment.amount
  #     end
  #   else
  #     return payments_amount
  #   end
  #   return payments_amount
  # end

  # def get_total(user)
  #   unless user.active_debt.nil?
  #     user.active_debt.total
  #   else
  #     return 0
  #   end
  # end
end
