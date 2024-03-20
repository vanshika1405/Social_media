require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) do
        {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          password: Faker::Internet.password(min_length: 6),
          phone: Faker::Number.number(digits: 10)
        }
      end

      it 'creates a new user' do
        post '/users', params: { user: valid_attributes }
        puts "Response status: #{response.status}"  
        puts "Response body: #{response.body}"      
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['user']).to be_present
      end
      
    end
  end
  

  


describe 'PATCH #update' do
  let!(:user) { create(:user) }  

  context 'when user is authenticated' do
    it 'updates the user' do
      valid_token = TokenService.encode(user_id: user.id)  
      headers = { 'Authorization' => "Bearer #{valid_token}" }
      patch "/users/#{user.id}", params: { user: { name: 'Updated Name' } }, headers: headers
      expect(response).to have_http_status(:ok)
      
      
      parsed_response = JSON.parse(response.body)
      
     
      expect(parsed_response['name']).to eq('Updated Name')
    end
  end

  context 'when user is not authenticated' do
    it 'returns unauthorized status' do
      patch "/users/#{user.id}", params: { user: { name: 'Updated Name' } }
      expect(response).to have_http_status(:unauthorized)
  
    end
  end
end
end