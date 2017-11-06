module RentalPayload
  def rental_payload(rental)
    {
      'rental' => {
        'id' => rental.id,
        'name' => rental.name,
        'daily_rate' => rental.daily_rate,
        'user_id' => rental.user_id,
        'busy_days' => rental.busy_days.map(&:to_s)
      },
      'users' => users_payload([rental.user])['users'],
      'roles' => roles_payload(rental.user.roles)['roles']
    }
  end

  def rentals_payload(rentals)
    array = rentals.map { |item| rental_payload(item)['rental'] }
    users_array = rentals.map(&:user).flatten.uniq
    roles_array = users_array.map(&:roles).flatten.uniq

    {
      'users' => users_payload(users_array)['users'],
      'roles' => roles_payload(roles_array)['roles'],
      'rentals' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include RentalPayload, type: :request
end
