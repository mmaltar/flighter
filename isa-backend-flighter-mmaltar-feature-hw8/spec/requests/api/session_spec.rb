RSpec.describe 'Session API', type: :request do
  include TestHelpers::JsonResponse
  describe 'POST /api/session' do
    let!(:user) { FactoryBot.create(:user) }

    context 'when params are valid' do
      it 'successfully creates session' do
        post '/api/session/',
             params: { session: { email: user.email, password: user.password } }

        expect(response).to have_http_status(:created)
      end

      it 'contains token and user' do
        post '/api/session/',
             params: { session: { email: user.email, password: user.password } }

        expect(json_body[:session]).to include(:token, :user)
      end

      it 'contains correct token value' do
        post '/api/session/',
             params: { session: { email: user.email, password: user.password } }

        expect(json_body[:session]).to include(token: user.token)
      end
    end

    context 'when params are invalid' do
      it 'returns 400: bad request' do
        post '/api/session/',
             params: { session: { email: user.email, password: 'wrongpass' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'contains errors' do
        post '/api/session',
             params: { session: { email: user.email, password: 'wrongpass' } }

        expect(json_body[:errors]).to include(:credentials)
      end
    end
  end

  describe 'DELETE /api/session' do
    let!(:user) { FactoryBot.create(:user) }

    it 'successfully destroys session' do
      delete '/api/session/',
             headers: { Authorization: user.token }

      expect(response).to have_http_status(:no_content)
    end

    it 'changes user token' do
      delete '/api/session/',
             headers: { Authorization: user.token }
      expect(User.find(user.id).token).not_to eq(user.token)
    end
  end
end
