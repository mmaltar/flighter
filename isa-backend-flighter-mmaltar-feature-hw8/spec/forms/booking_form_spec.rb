RSpec.describe BookingForm do
  let(:booking_form) { described_class.new }
  let(:flight) do
    FactoryBot.create(:flight, flys_at: Time.current + 10.hours,
                               lands_at: Time.current + 11.hours)
  end
  let(:user) { FactoryBot.create(:user) }

  it 'calculates seat price when creating a new record' do
    booking = FactoryBot.build(:booking, flight: flight, user: user)
    form = described_class.new(booking.attributes)

    form.save
    expect(form.seat_price)
      .to eq(FlightCalculator.new(form.flight).price)
  end

  it 'recalculates seat price when number of seats is changed' do
    booking = FactoryBot.create(:booking, seat_price: 1, flight: flight,
                                          user: user)
    booking.no_of_seats += 1
    form = ActiveType.cast(booking, described_class)

    expect { form.save }.to(change { booking.reload.seat_price })
  end
end
