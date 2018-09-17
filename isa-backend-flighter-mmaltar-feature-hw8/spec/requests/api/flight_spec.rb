RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  let(:authenticated_user) { FactoryBot.create(:user) }

  describe 'GET /flights' do
    context 'when authenticated' do
      let(:past_flight) do
        FactoryBot.create(:flight, flys_at: 10.hours.ago,
                                   lands_at: 9.hours.ago)
      end

      before do
        past_flight
        FactoryBot.create_list(:flight, 3)
      end

      it 'does not return inactive flights' do
        get '/api/flights',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flights].reduce({}, :merge))
          .not_to include(id: past_flight.id)
      end

      it 'successfully returns a list of flights' do
        get '/api/flights',
            headers: { Authorization: authenticated_user.token }
        expect(json_body[:flights].length).to eq(3)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/flights'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /flights?:company_id' do
    context 'when authenticated' do
      let(:company) { FactoryBot.create(:company) }
      let(:other_company) { FactoryBot.create(:company) }
      let(:flight) { FactoryBot.create(:flight, company: company) }
      let(:other_flight) { FactoryBot.create(:flight, company: other_company) }

      before do
        flight
        other_flight
      end

      it 'returns flights for provided company ids' do
        get "/api/flights?company_id=#{company.id}",
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flights].reduce({}, :merge)).to include(id: flight.id)
      end

      it 'does not return flights for companies whose ids are not provided' do
        get "/api/flights?company_id=#{company.id}",
            headers: { Authorization: authenticated_user.token }
        expect(json_body[:flights].reduce({}, :merge))
          .not_to include(id: other_flight.id)
      end
    end
  end

  describe 'GET /flights/:id' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when authorized' do
      it 'returns a single flight' do
        get "/api/flights/#{flight.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'contains attributes' do
        get "/api/flights/#{flight.id}",
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flight]).to include(name: flight.name,
                                              base_price: flight.base_price,
                                              no_of_seats: flight.no_of_seats)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get "/api/flights/#{flight.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /flights' do
    let(:company) { FactoryBot.create(:company) }

    context 'when authorized' do
      it 'successfully creates a flight' do
        post '/api/flights/',
             params: { flight: FactoryBot.attributes_for(:flight)
                                         .merge(company_id: company.id) },
             headers: { Authorization: authenticated_user.token }
        expect(response).to have_http_status(:created)
      end

      it 'contains attributes' do
        post '/api/flights/',
             params: { flight: FactoryBot.attributes_for(:flight)
                                         .merge(company_id: company.id) },
             headers: { Authorization: authenticated_user.token }
        expect(json_body[:flight]).to include(:company_id, :name, :base_price,
                                              :no_of_seats)
      end

      it 'increases flight count by 1' do
        expect do
          post '/api/flights/',
               params: { flight: FactoryBot.attributes_for(:flight)
                                           .merge(company_id: company.id) },
               headers: { Authorization: authenticated_user.token }
        end.to change(Flight, :count).by(1)
      end
    end

    context 'when authorized and params are invalid' do
      it 'returns errors' do
        post '/api/flights',
             params: { flight: { base_price: 0 } },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:errors]).to include(:base_price)
      end
    end
  end

  describe 'DELETE /flights:id' do
    let(:flight) { FactoryBot.create(:flight) }

    before { flight }

    context 'when authorized' do
      it 'successfully deletes a flight' do
        delete "/api/flights/#{flight.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:no_content)
      end

      it 'decreases flights count by 1' do
        expect do
          delete "/api/flights/#{flight.id}",
                 headers: { Authorization: authenticated_user.token }
        end.to change(Flight, :count).by(-1)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        delete "/api/companies/#{flight.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /flights:id' do
    let(:flight) { FactoryBot.create(:flight) }

    before { flight }

    context 'when authorized' do
      it 'changes flight attributes' do
        put "/api/flights/#{flight.id}",
            params: { flight: { base_price: 1, no_of_seats: 1 } },
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:flight]).to include(base_price: 1, no_of_seats: 1)
      end

      it 'sucessfully updates flight' do
        put "/api/flights/#{flight.id}",
            params: { flight: { base_price: 1 } },
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        put "/api/companies/#{flight.id}",
            params: { flight: { no_of_seats: 1 } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
