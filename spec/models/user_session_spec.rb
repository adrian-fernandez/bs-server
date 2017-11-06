# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  access_token :string(128)      not null
#  user_agent   :string
#  ip_address   :inet
#  accessed_at  :datetime
#  revoked_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe UserSession do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user) }

  let!(:user_session1) { create :user_session, accessed_at: 1.day.ago }
  let!(:user_session2) { create :user_session, user: user_session1.user, accessed_at: 3.days.ago, revoked_at: nil }
  let!(:user_session3) { create :user_session, user: user_session1.user, accessed_at: 4.weeks.ago, revoked_at: nil }
  let!(:user_session4) do
    create :user_session, user: user_session1.user, accessed_at: 2.days.ago, revoked_at: 1.day.ago
  end

  describe '.active scope' do
    it 'should return active user_sessions' do
      expect(UserSession.active.to_a).to eq([user_session1, user_session2])
    end
  end

  describe '.inactive scope' do
    it 'should return active user_sessions' do
      expect(UserSession.inactive.to_a).to eq([user_session3, user_session4])
    end
  end

  describe '.authenticate' do
    it 'should return the matching user_session' do
      token = user_session2.access_token
      expect(UserSession.authenticate(token)).to eq(user_session2)
    end

    it 'should return nil if no active user_session found' do
      expect(UserSession.authenticate('some-random-token-that-does-not-exists')).to be_nil
    end
  end

  describe '.revoke!' do
    it 'should revoke the user_session' do
      user_session1.revoke!
      expect(UserSession.active).to eq([user_session2])
    end
  end

  describe '#destroy_aged_sessions' do
    it 'should destroy revoked sessions' do
      UserSession.destroy_aged_sessions
      expect(UserSession.all.to_a).to eq(UserSession.active.to_a)
    end
  end

  describe '#newest' do
    it 'should return the last user session' do
      expect(UserSession.newest(user_session1.user)).to eq(user_session1)
    end
  end

  describe '.revoke!' do
    it 'should revoke the user_session' do
      user_session1.revoke!
      expect(UserSession.active).to eq([user_session2])
    end
  end

  describe '.access' do
    it 'should update with request info' do
      Request = Struct.new(:ip, :user_agent)
      some_ip = Faker::Internet.ip_v4_address
      some_user_agent = 'Microsucks Internet Rexplorer'
      user_session1.access(Request.new(some_ip, some_user_agent))

      expect(user_session1.accessed_at).to eq(Time.now.utc.to_s(:iso8601))
      expect(user_session1.ip_address).to eq(some_ip)
      expect(user_session1.user_agent).to eq(some_user_agent)
    end
  end

  describe 'Hooks' do
    let!(:blank_user_session) { build :user_session, ip_address: Faker::Internet.ip_v4_address }

    describe '.set_unique_token' do
      it 'should set unique_token' do
        blank_user_session.save
        expect(blank_user_session.access_token).to_not be_nil
      end
    end
  end
end
