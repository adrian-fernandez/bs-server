require 'rails_helper'

RSpec.describe User do
  subject { build :client }

  describe 'Associations' do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:roles) }
    it { is_expected.to have_many(:rentals) }
    it { is_expected.to have_many(:bookings) }
  end

  describe 'Validations' do
    before { create :client }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
