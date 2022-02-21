class LoanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if user_is_loan_officer?
    end

    def user_is_loan_officer?
    user.profile.nil?
    end
  end

  def show?
    user_is_loan_officer?
  end

  def create?
    user_is_loan_officer?
  end

  private

  def user_is_loan_officer?
    user.profile.nil?
  end
end
