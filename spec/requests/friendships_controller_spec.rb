require 'rails_helper'

RSpec.describe FriendshipsController, type: :request do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }

  describe 'POST /friendships' do
    context 'when the friend request is valid' do
      it 'creates a new friendship' do
        post '/friendships', params: { friend_id: friend.id }, headers: { 'Authorization': "Bearer #{token}" }
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('id', 'status')
        expect(Friendship.last.friend_id).to eq(friend.id)
      end
    end

    context 'when the friend request is not valid due to cooldown period' do
        it 'returns unprocessable_entity status with appropriate error message' do
          friendship = create(:friendship, user: friend, friend: user, status: 'rejected', last_declined_at: Time.now)
  
          post '/friendships', params: { friend_id: friend.id }, headers: { 'Authorization': "Bearer #{token}" }
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include('error')
          expect(JSON.parse(response.body)['error']).to eq("Cannot send friend request yet. Cooldown period active")
        end
      end
      
      
    #   context 'when the friend request is not valid due to other errors' do
    #     it 'returns unprocessable_entity status with error messages' do
    #       # Create a friendship instance that will fail validation
    #       friendship = build(:friendship, user: @current_user, friend: friend)
      
    #       post '/friendships', params: { friend_id: friend.id }, headers: { 'Authorization': "Bearer #{token}" }
          
    #       expect(response).to have_http_status(:unprocessable_entity)
    #       expect(JSON.parse(response.body)).to include('errors')
    #       # Assuming 'Validation error message' is the expected error message
    #       expect(JSON.parse(response.body)['errors']).to eq(['Validation error message'])
    #     end
    #   end
      
      
  end

  describe 'PATCH /friendships/:id/accept' do
    let(:friendship) { create(:friendship, user: friend, friend: user) }
  
    it 'accepts the friend request' do
      patch "/friendships/#{friendship.id}/accept", headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('id', 'status')
      expect(friendship.reload.status).to eq('accepted')
    end
  end
  

  describe 'DELETE /friendships/:id/reject' do
    let(:friendship) { create(:friendship, user: friend, friend: user) }

    it 'rejects the friend request' do
      delete "/friendships/#{friendship.id}/reject", headers: { 'Authorization': "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message')
      expect { friendship.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
