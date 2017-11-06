module RolePayload
  def role_payload(role)
    {
      'role' => {
        'id' => role.id,
        'name' => role.name
      }
    }
  end

  def roles_payload(roles)
    array = roles.map { |item| role_payload(item)['role'] }

    {
      'roles' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include RolePayload, type: :request
end
