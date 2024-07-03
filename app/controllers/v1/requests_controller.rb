module V1
  class RequestsController < ApplicationController
    before_action :set_request, only: [:show, :update, :destroy, :request_to_cancel]

    def index
      @requests = Request.all
      authorize @requests
      json_response(@requests)
    end

    def show
      authorize @request
      include_options = {}
      include_options[:approvals] = { include: :approval_user } if @request.approvals.present?
      json_response(@request, include: include_options)
    end
  
    def create
      @request = current_user.requests.new(request_params)
      # authorize_request
      authorize @request
      @request.save!
      json_response(@request, :created)
    end
  
    def update
      authorize @request
  
      if @request.approvals.none?
        @request.update!(request_params)
        json_response(@request)
      else
        json_response({ error: 'Request cannot be updated after approval' }, :forbidden)
      end
    end
  
    def destroy
      authorize @request
  
      if @request.approvals.none?
        @request.destroy!
        head :no_content
      else
        json_response({ error: 'Request cannot be deleted after approval' }, :forbidden)
      end
    end

    # def initiate_approval
    # end

    # def approve
    # end

    # def cancel
    # end

    # def reject
    # end
  
    def request_to_cancel
      authorize @request
  
      if @request.approval_initiated?
        # Notify approval users
        json_response({ notice: 'Cancel request sent to approvers' }, :ok)
      else
        json_response({ error: 'Request is not in a state that can be cancelled' }, :forbidden)
      end
    end
  
    private
  
    def set_request
      @request = Request.find(params[:id])
    end
  
    def request_params
      params.require(:request).permit(:title, :amount_cents, :description)
    end
  end
end