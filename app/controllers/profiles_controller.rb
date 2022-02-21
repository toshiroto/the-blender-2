class ProfilesController < ApplicationController
before_action :set_profile, only: [:show, :edit, :update]
  def index
    if params[:query].present?
      @profiles = policy_scope(Profile).global_search(params[:query])
    else
      @profiles = Profile.all
      @profiles = policy_scope(Profile)
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'list.html', locals: { profiles: @profiles } }
    end
  end

  def show
    @user = User.new
    @weekly_payment = WeeklyPayment.new
  end

  def new
    @profile = Profile.new
    authorize @profile
  end

  def create
    @profile = Profile.new(profile_params)
    authorize @profile
    if @profile.save
      redirect_to profiles_show_path(@profile)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    authorize @profile
    if @profile.save
      redirect_to profile_path(@profile)
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:village, :phone_number, :birthday, :join_date, :business_type, :user_id)
  end

  def set_profile
    @profile = Profile.find(params[:id])
    authorize @profile
  end
end
