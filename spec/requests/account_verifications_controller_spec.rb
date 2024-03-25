require 'rails_helper'

RSpec.describe AccountVerificationsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }

  describe 'POST /account_verifications' do
    it 'sends an account verification email' do
      expect(UserMailer).to receive_message_chain(:with, :account_verification, :deliver_now)

      post '/account_verifications', headers: { 'Authorization': "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message')
    end
  end

  describe 'PATCH /account_verifications' do
    it 'verifies the account' do
      patch '/account_verifications', headers: { 'Authorization': "Bearer #{token}" }
      
      user.reload 
      expect(user.verified).to eq(true)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message')
    end
  end
end
