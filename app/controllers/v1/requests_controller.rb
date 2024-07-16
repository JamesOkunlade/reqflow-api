module V1
  class RequestsController < ApplicationController
    before_action :set_request, only: [:show, :update, :destroy]

    def index
      @requests = find_requests
      authorize @requests
      json_response(@requests)
    end

    def show
      authorize @request
      json_response(@request)
    end
  
    def create
      @request = current_user.requests.new(request_params)
      authorize @request

      ActiveRecord::Base.transaction do
        @request.save!
        @request.create_next_approval
      end
      json_response(@request, :created)
    end
  
    def update
      authorize @request
      @request.update!(request_params)
      json_response(@request)
    rescue Pundit::NotAuthorizedError
      json_response({ error: 'Request cannot be updated after approval' }, :forbidden)
    end
  
    def destroy
      authorize @request  
      @request.destroy!
      head :no_content
    rescue Pundit::NotAuthorizedError
      json_response({ error: 'Request cannot be deleted after approval' }, :forbidden)
    end
  
    private
  
    def set_request
      @request = Request.includes(approvals: :user, approvals: { approval_user: :user }).find(params[:id])
    end
  
    def request_params
      params.require(:request).permit(:title, :amount_cents, :description)
    end

    def find_requests
      Request.includes(approvals: { approval_user: :user }).order(updated_at: :desc)
    end
  end
end
