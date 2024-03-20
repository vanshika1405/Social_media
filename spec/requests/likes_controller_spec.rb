require 'rails_helper'

RSpec.describe "Likes", type: :request do
    let(:user) { create(:user) }
    let(:token) { TokenService.encode(user_id: user.id) }
  
    describe "POST /likes" do
      context "with valid params" do
        let(:post_record) { create(:post) }
 
        
        it "creates a new like" do
          post "/likes", params: { likeable_type: 'Post', likeable_id: post_record.id }, headers: { 'Authorization' => "Bearer #{token}" }

          
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).not_to be_empty
        end
      end
      
      context "with invalid params" do
        it "returns unprocessable_entity status" do
          post "/likes", params: { likeable_type: 'InvalidType', likeable_id: 1 }, headers: { 'Authorization' => "Bearer #{token}" }
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["error"]).to eq("Invalid likeable type")
        end
      end
    end
    describe "DELETE /likes/:id" do
      context "when the like exists" do
        let!(:likeable) { create(:post, user: user) } 
        let!(:like) { create(:like, user: user, likeable: likeable) }
    
        it "deletes the like" do
         
          delete "/likes/#{like.id}", headers: { 'Authorization': "Bearer #{token}" }
          expect(response).to have_http_status(:no_content)
        end
      end
    
      context "when the like does not exist" do
        it "returns a not found status" do
        
          delete "/likes/9999", headers: { 'Authorization': "Bearer #{token}" }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    
    
  end
