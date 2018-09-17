RSpec.describe CompaniesQuery do
  let(:first_company) { FactoryBot.create(:company) }
  let(:second_company) { FactoryBot.create(:company) }
  let(:first_flight) do
    FactoryBot.create(:flight, base_price: 150, flys_at: Time.current + 10.days,
                               lands_at: Time.current + 11.days,
                               company: first_company)
  end
  let(:second_flight) do
    FactoryBot.create(:flight, base_price: 20, flys_at: Time.current + 12.days,
                               lands_at: Time.current + 13.days,
                               company: first_company)
  end

  let(:first_booking) do
    FactoryBot.create(:booking, no_of_seats: 2, flight: first_flight)
  end
  let(:second_booking) do
    FactoryBot.create(:booking, no_of_seats: 3, flight: first_flight)
  end
  let(:second_flight_booking) do
    FactoryBot.create(:booking, no_of_seats: 4, flight: second_flight)
  end

  before do
    first_booking
    second_booking
    second_flight_booking
  end

  it 'returns correct total revenue for company' do
    rev = first_booking.no_of_seats * first_booking.seat_price +
          second_booking.no_of_seats * second_booking.seat_price +
          second_flight_booking.no_of_seats * second_flight_booking.seat_price

    expect(described_class.new.with_stats[0].total_revenue).to eq(rev)
  end

  it 'returns correct number of booked seats for company' do
    seats = first_booking.no_of_seats + second_booking.no_of_seats +
            second_flight_booking.no_of_seats

    expect(described_class.new.with_stats[0].total_no_of_booked_seats)
      .to eq(seats)
  end
end
