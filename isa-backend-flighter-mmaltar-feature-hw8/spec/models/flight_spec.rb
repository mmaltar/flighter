RSpec.describe Flight do
  let(:company) { FactoryBot.create(:company) }
  let(:flight) do
    FactoryBot.create(:flight, flys_at: Time.current,
                               lands_at: Time.current + 3.hours,
                               company: company)
  end

  before do
    company
    flight
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:flys_at) }
  it { is_expected.to validate_presence_of(:lands_at) }
  it { is_expected.to validate_presence_of(:base_price) }

  describe 'uniqueness within a scope' do
    it {
      is_expected.to validate_uniqueness_of(:name).case_insensitive
                                                  .scoped_to(:company_id)
    }
  end

  it 'flies at before lands at' do
    flight =
      FactoryBot.build(:flight, flys_at: 1.hour.ago, lands_at: 2.hours.ago)
    flight.valid?

    expect(flight.errors[:lands_at]).to include('must be after flys_at')
  end

  it 'base price should be > 0' do
    is_expected.to validate_numericality_of(:base_price).is_greater_than(0)
  end

  it 'returns errors when overlapping with flight from same company' do
    flight = FactoryBot.build(:flight, flys_at: Time.current + 1.hour,
                                       lands_at: Time.current + 4.hours,
                                       company: company)
    flight.valid?
    expect(flight.errors[:flys_at])
      .to include('flights from same company must not overlap')
  end
end
