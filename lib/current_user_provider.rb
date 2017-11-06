class CurrentUserProvider
  ACCESS_TOKEN_KEY ||= :access_token
  CURRENT_USER_KEY ||= '_BOOKINGSYNC_CURRENT_USER'.freeze

  def initialize(env, session)
    @env = env
    @request = Rack::Request.new(env)
    @session = session
  end

  def current_user
    return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

    @env[CURRENT_USER_KEY] = fetch_current_user
  end

  def current_session
    @_current_session ||= (UserSession.find_by(access_token: auth_token) if valid_auth_token?)
  end

  def sign_in(user, session)
    user_session = UserSession.new(user: user)
    user_session.access(@request)
    session[ACCESS_TOKEN_KEY] = user_session.access_token

    @env[CURRENT_USER_KEY] = user
  end

  def sign_out(session)
    user_session = UserSession.where(access_token: auth_token)
    user_session&.destroy_all

    session[ACCESS_TOKEN_KEY] = nil
    @env[CURRENT_USER_KEY] = nil
  end

  private

    def auth_token
      @session[ACCESS_TOKEN_KEY] || @env['HTTP_X_API_TOKEN']
    end

    def valid_auth_token?
      auth_token&.length == 32
    end

    def fetch_current_user
      return unless valid_auth_token?

      UserSession.authenticate(auth_token).try(:user)
    end
end
