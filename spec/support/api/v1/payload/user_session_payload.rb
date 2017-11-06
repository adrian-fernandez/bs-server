module UserSessionPayload
  def user_session_payload(user_session, user)
    {
      'session' => {
        'id' => user_session.id,
        'access_token' => user_session.access_token,
        'accessed_at' => user_session.accessed_at&.strftime('%Y-%m-%d'),
        'revoked_at' => user_session.revoked_at&.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
        'created_at' => user_session.created_at&.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      },
      'user' => user_payload(user)['user']

    }
  end

  def user_sessions_payload(user_sessions)
    array = user_sessions.map { |item| user_session_payload(item)['user_session'] }

    {
      'user_sessions' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include UserSessionPayload, type: :request
end
