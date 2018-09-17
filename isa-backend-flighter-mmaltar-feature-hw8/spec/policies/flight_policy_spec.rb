require 'rails_helper'
RSpec.describe FlightPolicy do
  subject { described_class.new(user, flight) }

  let(:company) { FactoryBot.create(:company) }
  let(:flight) { FactoryBot.create(:flight, company: company) }

  context 'when authenticated' do
    let(:user) { FactoryBot.create(:user) }

    it do
      is_expected.to permit_actions([:index, :create, :show, :update, :destroy])
    end
  end
end
