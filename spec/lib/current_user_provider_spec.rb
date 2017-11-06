require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CurrentUserProvider do
  let!(:user) { create :user }
  let!(:user_session) { UserSession.create(user: user, accessed_at: Time.now.utc.to_s(:iso8601)) }
  let!(:user_session2) { UserSession.create(user: @admin_user, accessed_at: Time.now.utc.to_s(:iso8601)) }
  let(:provider) do
    CurrentUserProvider.new({ 'HTTP_X_AUTH_TOKEN' => user_session.access_token }, {})
  end
  let(:provider2) do
    CurrentUserProvider.new({ 'HTTP_X_AUTH_TOKEN' => '' }, {})
  end
  after(:all) { UserSession.destroy_all }

  describe '.current_session' do
    context 'When there is a session' do
      it 'returns the session' do
        expect(provider.current_session).to eq(user_session)
      end
    end

    context 'When there is no session' do
      it 'returns nil' do
        expect(provider2.current_session).to be_nil
      end
    end
  end

  describe '.sign_in' do
    it 'creates the session' do
      provider.sign_in(@admin_user, {})

      expect(UserSession.count).to eq(3)
      provider = CurrentUserProvider.new({ 'HTTP_X_AUTH_TOKEN' => UserSession.last.access_token }, {})
      expect(provider.current_session.user.id).to eq(@admin_user.id)
    end
  end

  describe '.sign_out' do
    it 'returns the session' do
      provider.sign_in(user, {})
      session = UserSession.find_by(access_token: user_session.access_token)
      provider.sign_out({})

      expect(UserSession.where(access_token: session.access_token).count).to eq(0)
    end
  end

  describe '.current_user' do
    it 'returns the user' do
      provider.sign_in(@admin_user, {})
      provider = CurrentUserProvider.new({ 'HTTP_X_AUTH_TOKEN' => UserSession.last.access_token }, {})
      expect(provider.current_user.id).to eq(@admin_user.id)
    end
  end
end
