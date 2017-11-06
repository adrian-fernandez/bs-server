module UserPayload
  def user_payload(user)
    {
      'user' => {
        'id' => user.id,
        'admin' => user.admin?,
        'email' => user.email,
        'role_ids' => user.role_ids,
        'permissions' => user.permissions
      },
      'roles' => roles_payload(user.roles)['roles']
    }
  end

  def users_payload(users)
    array = users.map { |item| user_payload(item)['user'] }

    {
      'roles' => roles_payload(users.map(&:roles).flatten.uniq)['roles'],
      'users' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include UserPayload, type: :request
end
