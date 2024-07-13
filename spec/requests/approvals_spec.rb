require 'rails_helper'

RSpec.describe 'Approvals', type: :request do
  let(:user) { create(:user, clearance_level: 2) }
  let(:user2) { create(:user, clearance_level: 1) }
  let!(:request) { create(:request, user: user2) }
  let!(:approval) { create(:approval, request: request) }
  let(:approval_id) { approval.id }
  let(:headers) { valid_headers(user) }

  describe 'GET /approvals index action' do
    before do
      create_list(:approval, 5, request: request, status: 'approved')
      create_list(:approval, 3, request: request, status: 'rejected')
      get '/approvals', params: {}, headers: headers
    end

    it 'returns all approvals with status approved or rejected' do
      expect(json).not_to be_empty
      expect(json.size).to eq(8)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /approvals/:id/approve approve action' do
    context 'when the approval exists and user has higher clearance and has not already approved' do
      before { post "/approvals/#{approval_id}/approve", params: {}, headers: headers }

      it 'approves the approval' do
        expect(response).to have_http_status(200)
        expect(json['status']).to eq('approved')
        expect(approval.approval_user.user).to eq(user)
      end
    end

    context 'when the approval does not exist' do
      let(:approval_id) { 0 }
      before { post "/approvals/#{approval_id}/approve", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Approval/)
      end
    end

    context 'when the user has already approved' do
      let!(:approval_user) { create(:approval_user, approval: approval, user: user) }
      before { post "/approvals/#{approval_id}/approve", params: {}, headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
        expect(json['error']).to eq('You are not authorized to approve this request')
      end
    end

    context 'when the user does not have higher clearance' do
      let(:user2) { create(:user, clearance_level: 3) }
      before { post "/approvals/#{approval_id}/approve", params: {}, headers: valid_headers(user2) }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
        expect(json['error']).to eq('You are not authorized to approve this request')
      end
    end
  end

  describe 'POST /approvals/:id/reject reject action' do
    context 'when the approval exists and user has higher clearance and has not already approved' do
      before { post "/approvals/#{approval_id}/reject", params: {}, headers: headers }

      it 'rejects the approval' do
        expect(response).to have_http_status(200)
        expect(json['status']).to eq('rejected')
        expect(approval.approval_user.user).to eq(user)
      end
    end

    context 'when the approval does not exist' do
      let(:approval_id) { 0 }
      before { post "/approvals/#{approval_id}/reject", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Approval/)
      end
    end

    context 'when the user has already approved' do
      let!(:approval_user) { create(:approval_user, approval: approval, user: user) }
      before { post "/approvals/#{approval_id}/reject", params: {}, headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
        expect(json['error']).to eq('You are not authorized to reject this request')
      end
    end

    context 'when the user does not have higher clearance' do
      let(:user2) { create(:user, clearance_level: 3) }
      before { post "/approvals/#{approval_id}/reject", params: {}, headers: valid_headers(user2) }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
        expect(json['error']).to eq('You are not authorized to reject this request')
      end
    end
  end
end
