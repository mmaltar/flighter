require 'rails_helper'
RSpec.describe CompanyPolicy do
  subject { described_class.new(user, company) }

  let(:company) { FactoryBot.create(:company) }

  context 'when authenticated' do
    let(:user) { FactoryBot.create(:user) }

    it do
      is_expected.to permit_actions([:index, :create, :show, :update, :destroy])
    end
  end
end
