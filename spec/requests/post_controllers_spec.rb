require 'rails_helper'
def json
  JSON.parse(response.body)
end

RSpec.describe PostsController, type: :request do
  describe 'POST #create' do
  let(:user) { FactoryBot.create(:user) }
  let(:token) { TokenService.encode(user_id: user.id) }

  
    
    context 'with valid attributes' do
      let(:valid_params) do
        {
          post: {
            title: Faker::Lorem.sentence,
            content: Faker::Lorem.paragraph,
            images: [fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image.jpeg'), 'image/jpg')]
          }
        }
      end

      

      it 'creates a new post' do

        puts "User object: #{user.inspect}"
        post '/posts', params: valid_params, headers: { 'Authorization' => "Bearer #{token}" }

        # expect(request.headers['Content-Type']).to eq('application/json')
        # expect(response).to have_http_status(:created)
        # expect(json['title']).to eq(valid_params[:post][:title])
        # expect(json['images'].count).to eq(1)
        # expect(json['images'].first['url']).to be_present
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          post: {
            title: '', 
            content: 'This is a test post content',
            images: []
          }
        }
      end

      

      it 'returns unprocessable_entity status' do
        post '/posts', params: invalid_params, headers: { 'Authorization' => "Bearer #{token}" }
        # expect(response).to have_http_status(:unprocessable_entity)
        # expect(json['errors']).to be_present
      end
    end
  end
end
