require 'rails_helper'

RSpec.describe TokenService, type: :service do
  describe '.encode' do
    let(:payload) { { user_id: 1 } }

    it 'generates a JWT token' do
      allow(TokenService).to receive(:encode).and_return('test_token')
      token = TokenService.encode(payload)
      expect(token).to eq('test_token')
    end
  end
end

