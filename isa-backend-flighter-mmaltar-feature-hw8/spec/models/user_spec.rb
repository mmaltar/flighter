RSpec.describe User do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name) }
  it { is_expected.to validate_presence_of(:email) }

  describe 'uniqueness' do
    subject { FactoryBot.build(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
