class ApprovalPolicy < ApplicationPolicy
  def index?
    true
  end

  def approve?
    # true
    user_has_higher_clearance? && user_has_not_already_approved_request?
  end

  def reject?
    # true
    user_has_higher_clearance? && user_has_not_already_approved_request?
  end

  private

  def user_has_higher_clearance?
    user.clearance_level > record.request.user.clearance_level
  end

  def user_has_not_already_approved_request?
    !record.request.approvals.joins(:approval_user).where(approval_users: { user_id: user.id }).exists?
  end
end
