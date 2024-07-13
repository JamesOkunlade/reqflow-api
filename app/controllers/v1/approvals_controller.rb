module V1
  class ApprovalsController < ApplicationController
    before_action :set_approval, only: [:approve, :reject]

    def index
      @approvals = find_approvals
      authorize @approvals
      json_response(@approvals)
    end
  
    def approve
      authorize @approval
      
      if @approval.may_approve?
        @approval.transaction do
          @approval.approve!(current_user)
          @approval.request.initiate_approval! if @approval.request.may_initiate_approval?
          @approval.request.approve! if @approval.request.may_approve?
        end
        json_response(@approval)
      end
    rescue Pundit::NotAuthorizedError
      json_response({ error: 'You are not authorized to approve this request' }, :forbidden)
    end

    def reject
      authorize @approval
    
      if @approval.may_reject?
        @approval.transaction do
          @approval.reject!(current_user)
          @approval.request.reject! if @approval.request.may_reject?
        end
        json_response(@approval)
      end
    rescue Pundit::NotAuthorizedError
      json_response({ error: 'You are not authorized to reject this request' }, :forbidden)
    end
    

    private

    def set_approval
      @approval = Approval.find(params[:id])
    end

    def find_approvals
      scope = Approval.includes(:approval_user, :request)
      scope = scope.initiated
      scope
    end
  end
end


  

  

  
  


