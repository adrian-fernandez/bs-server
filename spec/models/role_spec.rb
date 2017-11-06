# == Schema Information
#
# Table name: bookings
#
#

require 'rails_helper'

RSpec.describe Role do
  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of(:name) }

  it 'should not be allowed to user "superadmin" as name' do
    role = build :role
    role.name = 'superadmin'

    expect(role.valid?).to be_falsey
  end

  describe '#permissions_guest' do
    let(:expected_permissions) do
      {
        admin: false,
        rentals: {
          index: true, show: true, create: true, update: false, destroy: false
        },
        bookings: {
          index: true, show: true, create: true, update: false, destroy: false
        },
        users: {
          index: false, show: true, create: false, update: false, destroy: false
        }
      }
    end

    it 'should return hash with default permissions' do
      expect(Role.permissions_guest).to eq(expected_permissions)
    end
  end

  describe '.admin?' do
    it 'should return true when name is admin' do
      role = build :role, name: 'admin'

      expect(role.admin?).to be_truthy
    end

    it 'should return false when name is superadmin' do
      role = build :role, name: 'superadmin'

      expect(role.admin?).to be_falsey
    end

    it 'should return false when name is not admin' do
      role = build :role, name: 'other_name'

      expect(role.admin?).to be_falsey
    end
  end

  describe '.superadmin?' do
    it 'should return true when name is superadmin' do
      role = build :role, name: 'superadmin'

      expect(role.superadmin?).to be_truthy
    end

    it 'should return false when name is admin' do
      role = build :role, name: 'admin'

      expect(role.superadmin?).to be_falsey
    end

    it 'should return false when name is not superadmin' do
      role = build :role, name: 'other_name'

      expect(role.superadmin?).to be_falsey
    end
  end
end
