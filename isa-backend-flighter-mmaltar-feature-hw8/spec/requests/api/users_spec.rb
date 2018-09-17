RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  let(:authenticated_user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET /users' do
    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      before { FactoryBot.create_list(:user, 3) }

      it 'successfully returns a list of users' do
        get '/api/users',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:users].length).to eq(4)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when authorized' do
      it 'returns a single user' do
        get "/api/users/#{authenticated_user.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'contains attributes' do
        get "/api/users/#{authenticated_user.id}",
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:user])
          .to include(first_name: authenticated_user.first_name,
                      last_name: authenticated_user.last_name,
                      email: authenticated_user.email)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get "/api/users/#{authenticated_user.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      it 'returns 403: forbidden' do
        get "/api/users/#{other_user.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /users?query=' do
    let(:query_user) { FactoryBot.create(:user, first_name: 'Marko') }

    before { query_user }

    context 'when authorized' do
      it 'returns filtered user' do
        get '/api/users?query=rk',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:users].reduce({}, :merge))
          .to include(id: query_user.id)
      end

      it 'does not return other users' do
        get '/api/users?query=rk',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:users].reduce({}, :merge))
          .not_to include(id: authenticated_user.id)
      end
    end
  end

  describe 'POST /users' do
    context 'when params are valid' do
      it 'successfully creates a user' do
        post '/api/users/',
             params: { user: FactoryBot.attributes_for(:user) }

        expect(response).to have_http_status(:created)
      end

      it 'increases user count by 1' do
        expect do
          post '/api/users/',
               params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'contains attributes' do
        post '/api/users/',
             params: { user: { first_name: 'Firstname', last_name: 'Lastname',
                               email: 'email@email.com',
                               password: 'password' } }
        expect(json_body[:user]).to include(first_name: 'Firstname',
                                            last_name: 'Lastname',
                                            email: 'email@email.com')
      end
    end

    it 'can not register without password' do
      post '/api/users/',
           params: { user: { first_name: 'Firstname', last_name: 'Lastname',
                             email: 'email@email.com',
                             password: '' } }

      expect(response).to have_http_status(:bad_request)
    end

    it 'can successfully register with password' do
      post '/api/users/',
           params: { user: { first_name: 'Firstname', last_name: 'Lastname',
                             email: 'email@email.com',
                             password: 'password' } }

      expect(response).to have_http_status(:created)
    end

    it 'created user with correct password' do
      post '/api/users/',
           params: { user: { first_name: 'Firstname', last_name: 'Lastname',
                             email: 'email@email.com',
                             password: 'password' } }

      user = User.find(json_body.dig(:user, :id))
      expect(user.authenticate('password')).to eq(user)
    end

    context 'when params are invalid' do
      it 'contains errors' do
        post '/api/users', params: { user: { first_first_name: 'A' } }

        expect(json_body[:errors]).to include(:first_name)
      end
    end
  end

  describe 'DELETE /users:id' do
    before { authenticated_user }

    context 'when authorized' do
      it 'successfully deletes a user' do
        delete "/api/users/#{authenticated_user.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:no_content)
      end

      it 'decreases users count by 1' do
        expect do
          delete "/api/users/#{authenticated_user.id}",
                 headers: { Authorization: authenticated_user.token }
        end.to change(User, :count).by(-1)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        delete "/api/users/#{authenticated_user.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      it 'returns 403: forbidden' do
        delete "/api/users/#{other_user.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /users:id' do
    context 'when authorized' do
      it 'changes user attributes' do
        put "/api/users/#{authenticated_user.id}",
            params: { user: { first_name: 'Mynewname' } },
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:user]).to include(first_name: 'Mynewname')
      end

      it 'sucessfully updates user' do
        put "/api/users/#{authenticated_user.id}",
            params: { user: { first_name: 'Mynewname' } },
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end
    end

    it 'can not unset password' do
      put "/api/users/#{authenticated_user.id}",
          params: { user: { password: nil } },
          headers: { Authorization: authenticated_user.token }

      expect(response).to have_http_status(:bad_request)
    end

    it 'can successfully change password' do
      put "/api/users/#{authenticated_user.id}",
          params: { user: { password: 'newpassword' } },
          headers: { Authorization: authenticated_user.token }

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when unauthenticated' do
    it 'returns 401: unauthorized' do
      put "/api/users/#{authenticated_user.id}",
          params: { user: { first_name: 'Mynewname' } }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when authenticated but not authorized' do
    it 'returns 403: forbidden' do
      put "/api/users/#{other_user.id}",
          params: { user: { first_name: 'Mynewname' } },
          headers: { Authorization: authenticated_user.token }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
