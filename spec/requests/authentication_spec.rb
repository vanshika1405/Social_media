
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /login' do
    let(:user) { FactoryBot.create(:user) }

    context 'with valid credentials' do
      it 'returns a valid token' do
        post '/login', params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:ok)

       
        json = JSON.parse(response.body)

       
        expect(json['token']).to be_present
      end
    end

    context 'with invalid credentials' do
        it 'returns unauthorized status' do
          invalid_user = FactoryBot.build(:user)
          post '/login', params: { email: invalid_user.email, password: invalid_user.password }
          expect(response).to have_http_status(:unauthorized)
  
         
          json = JSON.parse(response.body)
  
         
          expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
