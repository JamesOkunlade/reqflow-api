class RequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    # current_user.present?
    user.present?
  end

  def update?
    (user.clearance_level > record.user.clearance_level || user == record.user) && record.approvals.none?
  end

  def destroy?
    user == record.user && record.approvals.none?
  end

  def request_to_cancel?
    user == record.user && record.aasm_state == 'approval_initiated'
  end

  def permitted_attributes
    [:amount, :status]
  end
end
