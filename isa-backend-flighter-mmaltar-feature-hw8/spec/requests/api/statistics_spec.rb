RSpec.describe 'Statistics API', type: :request do
  include TestHelpers::JsonResponse

  let(:authenticated_user) { FactoryBot.create(:user) }

  describe 'GET /statistics/flights' do
    let(:company) { FactoryBot.create(:company) }
    let(:other_company) { FactoryBot.create(:company) }

    context 'when authenticated' do
      it 'successfully returns list of flights' do
        FactoryBot.create(:flight, company: company)
        FactoryBot.create(:flight, company: other_company)
        get '/api/statistics/flights',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flights].length).to eq(2)
      end

      it 'contains attributes' do
        flight = FactoryBot.create(:flight, company: company)
        get '/api/statistics/flights',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flights].reduce({}, :merge))
          .to include(flight_id: flight.id)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/statistics/flights'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /statistics/companies' do
    context 'when authenticated' do
      it 'successfully returns list of companies' do
        FactoryBot.create_list(:company, 3)

        get '/api/statistics/companies',
            headers: { Authorization: authenticated_user.token }
        expect(json_body[:companies].length).to eq(3)
      end

      it 'contains attributes' do
        company = FactoryBot.create(:company)
        get '/api/statistics/companies',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:companies].reduce({}, :merge))
          .to include(company_id: company.id)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/statistics/companies'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
