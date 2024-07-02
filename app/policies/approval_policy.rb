class ApprovalPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def approve?
    user_has_higher_clearance?
  end

  def reject?
    user_has_higher_clearance?
  end

  def undo_confirm?
    user_has_higher_clearance?
  end

  def cancel?
    user_has_higher_clearance?
  end

  def permitted_attributes_for(action) # Cancel action doesn't need as many
    [:status, :comment, :confirmed_by_id, :confirmed_at] 
      if %i[approve reject undo_confirm cancel].include?(action)
  end

  private

  def user_has_higher_clearance?
    user.clearance_level > record.request.user.clearance_level
  end
end
