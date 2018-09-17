RSpec.describe 'bookings API', type: :request do
  include TestHelpers::JsonResponse

  let(:authenticated_user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }
  let(:flight) { FactoryBot.create(:flight, company: company) }

  describe 'GET /bookings' do
    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      let(:booking) do
        FactoryBot.create(:booking, user: authenticated_user)
      end

      it 'returns only bookings created by user' do
        get '/api/bookings',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:bookings].reduce({}, :merge))
          .to all include(user: authenticated_user)
      end
    end

    it 'successfully returns a list of bookings' do
      FactoryBot.create_list(:booking, 3, flight: flight,
                                          user: authenticated_user)

      get '/api/bookings',
          headers: { Authorization: authenticated_user.token }

      expect(json_body[:bookings].length).to eq(3)
    end
  end

  describe 'GET /bookings?filter=active' do
    context 'when authenticated' do
      let(:active_flight) do
        FactoryBot.create(:flight, flys_at: Time.current + 10.hours,
                                   lands_at: Time.current + 12.hours)
      end

      it 'returns active bookings' do
        active_booking = FactoryBot.create(:booking, flight: active_flight,
                                                     user: authenticated_user)
        get '/api/bookings?filter=active',
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:bookings].reduce({}, :merge))
          .to include(id: active_booking.id)
      end
    end
  end

  describe 'GET /bookings/id' do
    let(:booking) do
      FactoryBot.create(:booking, user: authenticated_user)
    end

    context 'when authorized' do
      it 'returns a single booking' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end
    end

    it 'contains attributes' do
      get "/api/bookings/#{booking.id}",
          headers: { Authorization: authenticated_user.token }

      expect(json_body[:booking]).to include(seat_price: booking.seat_price,
                                             no_of_seats: booking.no_of_seats)
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        get "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      let(:booking) do
        FactoryBot.create(:booking, user: other_user)
      end

      it 'returns 403: forbidden' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /bookings' do
    let(:booking) { FactoryBot.build(:booking, flight: flight) }
    let(:overbooked_booking) do
      FactoryBot.build(:booking, no_of_seats: flight.no_of_seats + 1,
                                 flight: flight)
    end
    let(:booking_attributes) { booking.attributes }

    context 'when authenticated' do
      it 'successfully creates a booking' do
        post '/api/bookings/',
             params: { booking: booking_attributes },
             headers: { Authorization: authenticated_user.token }
        expect(response).to have_http_status(:created)
      end

      it 'contains attributes' do
        post '/api/bookings/',
             params: { booking: booking_attributes },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:booking]).to include(:flight,
                                               :no_of_seats, :seat_price)
      end

      it 'increases booking count by 1' do
        expect do
          post '/api/bookings/',
               params: { booking: booking_attributes },
               headers: { Authorization: authenticated_user.token }
        end.to change(Booking, :count).by(1)
      end

      it 'does not allow overbooking of flights' do
        post '/api/bookings/',
             params: { booking: overbooked_booking.attributes },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:errors]).to include(:flight)
      end
    end

    context 'when authorized and params are invalid' do
      it 'returns errors' do
        post '/api/bookings',
             params: { booking: booking.attributes.merge(flight_id: flight.id,
                                                         no_of_seats: 0) },
             headers: { Authorization: authenticated_user.token }

        expect(json_body[:errors]).to include(:no_of_seats)
      end
    end
  end

  describe 'DELETE /bookings:id' do
    let(:booking) do
      FactoryBot.create(:booking, user: authenticated_user)
    end

    before { booking }

    context 'when authorized' do
      it 'successfully deletes a booking' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:no_content)
      end

      it 'decreases bookings count by 1' do
        expect do
          delete "/api/bookings/#{booking.id}",
                 headers: { Authorization: authenticated_user.token }
        end.to change(Booking, :count).by(-1)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        delete "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated but not authorized' do
      let(:booking) { FactoryBot.create(:booking, user: other_user) }

      it 'returns 403: forbidden' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /bookings:id' do
    let(:booking) do
      FactoryBot.create(:booking, user: authenticated_user)
    end

    context 'when unauthenticated' do
      it 'returns 401: unauthorized' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { first_name: 'Mynewname' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:other_flight) do
        FactoryBot.create(:flight, base_price: 150,
                                   no_of_seats: 1000,
                                   flys_at: Time.current + 10.days,
                                   lands_at: Time.current + 11.days)
      end
      let(:other_booking) do
        FactoryBot.create(:booking, flight: other_flight,
                                    user: authenticated_user)
      end

      before { other_booking }

      it 'changes booking attributes' do
        put "/api/bookings/#{other_booking.id}",
            params: { booking: { no_of_seats: 1 } },
            headers: { Authorization: authenticated_user.token }

        expect(json_body[:booking]).to include(no_of_seats: 1, seat_price: 210)
      end

      it 'sucessfully updates booking' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 1 } },
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'does not change seat price when number of seats stays same' do
        expect do
          put "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: booking.no_of_seats } },
              headers: { Authorization: authenticated_user.token }
        end.not_to(change { booking.reload.seat_price })
      end
    end

    it 'returns errors when params are invalid' do
      put "/api/bookings/#{booking.id}",
          params: { booking: { no_of_seats: 0 } },
          headers: { Authorization: authenticated_user.token }

      expect(json_body[:errors]).to include(:no_of_seats)
    end

    context 'when authenticated but not authorized' do
      let(:booking) { FactoryBot.create(:booking, user: other_user) }

      it 'returns 403: forbidden' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 2 } },
            headers: { Authorization: authenticated_user.token }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
