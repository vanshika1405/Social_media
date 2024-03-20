require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }
  let(:post_record) { create(:post) }

  describe "POST /comments" do
    context "with valid params" do
      it "creates a new comment" do
        post "/comments", params: { commentable_type: 'Post', commentable_id: post_record.id, comment: { content: "This is a test comment." } }, headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity status" do
        post "/comments", params: { commentable_type: 'InvalidType', commentable_id: 1, comment: { content: "This is a test comment." } }, headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Commentable must exist")
      end
    end
  end

  describe "DELETE /comments/:id" do
    context "when the comment exists" do
      let!(:comment) { create(:comment, user: user, post: post_record) }

      it "deletes the comment" do
        delete "/comments/#{comment.id}", headers: { 'Authorization': "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Comment deleted successfully")
      end
    end

    context "when the comment does not exist" do
      it "returns a not found status" do
        delete "/comments/9999", headers: { 'Authorization': "Bearer #{token}" }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Comment not found")
      end
    end
  end
end
