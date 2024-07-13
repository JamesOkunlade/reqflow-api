class RequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user == record.user && record.approvals.initiated.none?
  end

  def destroy?
    user == record.user && record.approvals.initiated.none?
  end
end
