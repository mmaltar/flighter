RSpec.describe Booking do
  let(:flight)  { FactoryBot.create(:flight) }
  let(:booking) { FactoryBot.create(:booking, flight: flight) }

  before { booking }

  it { is_expected.to validate_presence_of(:no_of_seats) }
  it do
    is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0)
  end

  it 'is not in past' do
    flight = FactoryBot.create(:flight, flys_at: 1.hour.ago)
    booking = FactoryBot.build(:booking, flight: flight)
    booking.valid?

    expect(booking.errors[:flight]).to include('must not fly in past')
  end

  it 'does not overbook flight' do
    flight = FactoryBot.create(:flight, no_of_seats: 10,
                                        flys_at: Time.current + 10.hours,
                                        lands_at: Time.current + 11.hours)
    booking = FactoryBot.build(:booking, no_of_seats: 11, flight: flight)
    booking.valid?

    expect(booking.errors[:flight]).to include("can't be overbooked")
  end
end
