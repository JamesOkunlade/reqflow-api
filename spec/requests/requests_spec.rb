require 'rails_helper'

RSpec.describe 'Requests', type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:user1_requests) { create_list(:request, 5, user_id: user.id) }
  let!(:user2_requests) { create_list(:request, 5, user_id: user2.id) }
  let(:request_id) { user1_requests.first.id }
  let(:headers) { valid_headers(user) }

  describe 'GET /requests index action' do
    before { get '/requests', params: {}, headers: headers }
    # before { get 'requests' }

    it 'returns all requests' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /requests/:id show action' do
    before { get "/requests/#{request_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the request' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(request_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:request_id) { 121212 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Request/)
      end
    end
  end

  describe 'POST /requests create action' do
    let(:valid_attributes) do
      { title: 'Caterer fee', amount_cents: 200, description: 'Payment for the meal of 20 attendees', user_id: user.id }.to_json
    end

    context 'when the request is valid' do
      before { post '/requests', params: valid_attributes, headers: headers }

      it 'creates a request' do
        expect(json['title']).to eq('Caterer fee')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { title: 'Caterer fee' }.to_json }
      before { post '/requests', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Description can't be blank, Amount cents can't be blank/)
      end
    end
  end

  describe 'PUT /requests/:id update action' do
    let(:valid_attributes) { { amount_cents: 500 }.to_json }

    context 'when the record exists' do
      before { put "/requests/#{request_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json['amount_cents']).to eq(500)
      end
    end

    context 'when the record exists but there is already an approval with status approved on it' do
      let!(:approval) { create(:approval, request: user1_requests.first, status: 'approved') }
      before { put "/requests/#{request_id}", params: valid_attributes, headers: headers }

      it 'returns NotAuthorizedError' do
        expect(response).to have_http_status(403)
      end

      it 'returns a not authorized message' do
        expect(json['error']).to eq('Request cannot be updated after approval')
      end
    end
    
    context 'when the record exists but there is already an approval with status not approved or rejected' do
      let!(:approval) { create(:approval, request: user1_requests.first) }
      before { put "/requests/#{request_id}", params: valid_attributes, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the record' do
        expect(json['amount_cents']).to eq(500)
      end
    end
  end

  describe 'DELETE /requests/:id destroy action' do
    context 'when record can be deleted' do
      before { delete "/requests/#{request_id}", params: {}, headers: headers }
  
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when record exists but there is already an approval on it' do
      let!(:approval) { create(:approval, request: user1_requests.first, status: 'approved') }
      before { delete "/requests/#{request_id}", params: {}, headers: headers }

      it 'returns NotAuthorizedError' do
        expect(response).to have_http_status(403)
      end

      it 'returns a not authorized message' do
        expect(json['error']).to eq('Request cannot be deleted after approval')
      end
    end
   
    context 'when the record exists but there is already an approval with status not approved or rejected' do
      let!(:approval) { create(:approval, request: user1_requests.first) }
      before { delete "/requests/#{request_id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
