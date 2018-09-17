RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let(:authenticated_user) { FactoryBot.create(:user) }

  describe 'GET /companies' do
    context 'when authenticated' do
      before { FactoryBot.create_list(:company, 3) }

      it 'successfully returns a list of companies' do
        get '/api/companies',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:companies].length).to eq(3)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/companies'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /companies?filter=active' do
    context 'when authenticated' do
      let(:inactive_company) { FactoryBot.create(:company) }
      let(:past_flight) do
        FactoryBot.create(:flight, flys_at: 10.hours.ago,
                                   lands_at: 9.hours.ago,
                                   company: inactive_company)
      end

      before { inactive_company }

      it 'does not return inactive companies' do
        get '/api/companies?filter=active',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:companies].reduce({}, :merge))
          .not_to include(:inactive_company)
      end
    end
  end

  describe 'GET /companies/:id' do
    let(:company) { FactoryBot.create(:company) }

    context 'when authorized' do
      it 'returns a single company' do
        get "/api/companies/#{company.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'contains attributes' do
        get "/api/companies/#{company.id}",
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:company]).to include(name: company.name)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get "/api/companies/#{company.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /companies' do
    context 'when authorized' do
      it 'successfully creates a company' do
        post '/api/companies/',
             params: { company: FactoryBot.attributes_for(:company) },
             headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:created)
      end

      it 'increases company count by 1' do
        expect do
          post '/api/companies/',
               params: { company: FactoryBot.attributes_for(:company) },
               headers: { Authorization: authenticated_user.token }
        end.to change(Company, :count).by(1)
      end

      it 'contains attributes' do
        post '/api/companies/',
             params: { company: { name: 'Lufthansa' } },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:company]).to include(name: 'Lufthansa')
      end
    end

    context 'when authorized and params are invalid' do
      it 'returns errors' do
        post '/api/companies',
             params: { company: { name: '' } },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:errors]).to include(:name)
      end
    end
  end

  describe 'DELETE /companies:id' do
    let(:company) { FactoryBot.create(:company) }

    before { company }

    context 'when authorized' do
      it 'successfully deletes a company' do
        delete "/api/companies/#{company.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:no_content)
      end

      it 'decreases companies count by 1' do
        expect do
          delete "/api/companies/#{company.id}",
                 headers: { Authorization: authenticated_user.token }
        end.to change(Company, :count).by(-1)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        delete "/api/companies/#{company.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /companies:id' do
    let(:company) { FactoryBot.create(:company) }

    context 'when authorized' do
      it 'changes company attributes' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Lufthansa' } },
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:company]).to include(name: 'Lufthansa')
      end

      it 'sucessfully updates company' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Lufthansa' } },
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Mynewname' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
