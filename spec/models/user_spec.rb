require 'rails_helper'

RSpec.describe User do
  subject { build :user }

  describe 'Associations' do
    it { is_expected.to have_many(:rentals) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:user_sessions) }
    it { is_expected.to belong_to(:client) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Hooks' do
    let!(:some_user) { create :user, email: 'User@example.com', roles: [] }

    describe '.downcase_email' do
      it 'converts email' do
        expect(some_user.email).to eq('user@example.com')
      end
    end

    describe '.set_role' do
      it 'assign role' do
        expect(some_user.roles).to be_present
      end
    end
  end

  describe 'Role delegations' do
    it '.admin? should return true only for admins' do
      expect(@admin_user.admin?).to be_truthy
      expect(@superadmin_user.admin?).to be_falsey
      expect(@staff_user.admin?).to be_falsey
    end

    it '.superadmin? should return true only for superadmins' do
      expect(@admin_user.superadmin?).to be_falsey
      expect(@superadmin_user.superadmin?).to be_truthy
      expect(@staff_user.superadmin?).to be_falsey
    end
  end
end
