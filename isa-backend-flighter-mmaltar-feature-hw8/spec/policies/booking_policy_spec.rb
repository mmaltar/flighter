require 'rails_helper'
RSpec.describe BookingPolicy do
  subject { described_class.new(user, booking) }

  let(:company) { FactoryBot.create(:company) }
  let(:flight) { FactoryBot.create(:flight, company: company) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:booking) do
    FactoryBot.create(:booking, flight: flight, user: other_user)
  end

  context 'when authenticated but not authorized' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_actions([:index, :create]) }
    it { is_expected.to forbid_actions([:show, :update, :destroy]) }
  end

  context 'when authorized' do
    let(:past_flight) do
      FactoryBot.build(:flight, flys_at: 10.hours.ago,
                                lands_at: 9.hours.ago)
    end
    let(:user) { FactoryBot.create(:user) }
    let(:booking) do
      FactoryBot.build(:booking, flight: past_flight, user: user)
    end

    it 'does not allow to update booking whose flight already departed' do
      past_flight.save(validate: false)
      booking.save(validate: false)

      is_expected.to forbid_action(:update)
      booking.destroy
      past_flight.destroy
    end

    it { is_expected.to permit_actions([:index, :create, :show, :destroy]) }
  end
end
