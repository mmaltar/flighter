require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(user, FactoryBot.create(:user)) }

  context 'when authenticated but not authorized' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_actions([:index, :create]) }
    it { is_expected.to forbid_actions([:show, :update, :destroy]) }
  end
end
