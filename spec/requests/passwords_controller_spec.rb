require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }

  describe 'POST /passwords/generate_otp' do
    context 'when user is authenticated' do
      it 'generates and sends OTP' do
        post '/passwords/generate_otp', headers: { 'Authorization': "Bearer #{token}" }

        expect(request.headers['Authorization']).to eq("Bearer #{token}")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized error' do
        post '/passwords/generate_otp'
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
    
  end

  describe 'POST /passwords/reset_with_otp' do
    context 'when OTP is valid' do
      it 'verifies the OTP' do
        user.generate_otp
        post '/passwords/reset_with_otp', params: { otp: user.otp }, headers: { 'Authorization': "Bearer #{token}" }

        expect(request.headers['Authorization']).to eq("Bearer #{token}")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
      end
    end

    context 'when OTP is invalid' do
      it 'returns unprocessable entity error' do
        post '/passwords/reset_with_otp', params: { otp: 'invalid_otp' }, headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end

  describe 'PATCH /passwords/new_password' do
    context 'when user is authenticated' do
      it 'sets a new password' do
        new_password = 'new_password'
        patch '/passwords/new_password', params: { password: new_password }, headers: { 'Authorization': "Bearer #{token}" }

        expect(request.headers['Authorization']).to eq("Bearer #{token}")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message')
        expect(user.reload.authenticate(new_password)).to be_truthy
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized error' do
        patch '/passwords/new_password', params: { password: 'new_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error')
      end
    end
    
  end
end
