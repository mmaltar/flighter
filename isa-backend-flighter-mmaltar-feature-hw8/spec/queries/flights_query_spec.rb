RSpec.describe FlightsQuery do
  let(:company) { FactoryBot.create(:company) }
  let(:flight) do
    FactoryBot.create(:flight, base_price: 150, flys_at: Time.current + 10.days,
                               lands_at: Time.current + 11.days,
                               company: company)
  end

  let(:first_booking) do
    FactoryBot.create(:booking, no_of_seats: 2, flight: flight)
  end
  let(:second_booking) do
    FactoryBot.create(:booking, no_of_seats: 3, flight: flight)
  end

  before do
    first_booking
    second_booking
  end

  it 'returns correct revenue for flight' do
    rev = first_booking.no_of_seats * first_booking.seat_price +
          second_booking.no_of_seats * second_booking.seat_price

    expect(described_class.new.with_stats[0].revenue).to eq(rev)
  end

  it 'returns correct number of booked seats for flight' do
    seats = first_booking.no_of_seats + second_booking.no_of_seats

    expect(described_class.new.with_stats[0].no_of_booked_seats).to eq(seats)
  end
end
