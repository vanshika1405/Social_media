require 'rails_helper'

RSpec.describe BlockedUsersController, type: :request do
  let(:user) { create(:user) }
  let(:blocked_user) { create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }

  describe 'GET /blocked_users' do
    it 'returns the list of blocked users' do
      user.blocked_users << create(:blocked_user, user: user, blocked_user: blocked_user)

      get '/blocked_users', headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('blocked_users')
    end
  end

  describe 'POST /blocked_users/block' do
    it 'blocks the specified user' do
      post "/blocked_users/block", params: { user_id: blocked_user.id }, headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message')
    end
  end

  describe 'DELETE /blocked_users/unblock' do
    context 'when the user is found in the blocked list' do
      it 'unblocks the specified user' do
        user.blocked_users << create(:blocked_user, user: user, blocked_user: blocked_user)

        delete "/blocked_users/unblock", params: { user_id: blocked_user.id }, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
      end
    end

    context 'when the user is not found in the blocked list' do
      it 'returns a not found error message' do
        delete "/blocked_users/unblock", params: { user_id: blocked_user.id }, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end
end
