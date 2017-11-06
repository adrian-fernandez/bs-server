module BookingPayload
  def booking_payload(booking)
    {
      'booking' => {
        'id' => booking.id,
        'price' => booking.price,
        'days' => booking.days,
        'start_at' => booking.start_at.to_date.to_s,
        'end_at' => booking.end_at.to_date.to_s,
        'user_id' => booking.user_id,
        'rental_id' => booking.rental_id
      },
      'users' => users_payload([booking.user, booking.rental.user])['users'],
      'roles' => roles_payload([booking.user.roles, booking.rental.user.roles].flatten.uniq)['roles'],
      'rentals' => rentals_payload([booking.rental])['rentals']
    }
  end

  def bookings_payload(bookings)
    array = bookings.map { |item| booking_payload(item)['booking'] }
    users_array = (bookings.map(&:user).flatten + bookings.map { |x| x.rental.user }.flatten).uniq
    roles_array = users_array.map(&:roles).flatten.uniq

    {
      'rentals' => rentals_payload(bookings.map(&:rental).flatten.uniq)['rentals'],
      'users' => users_payload(users_array)['users'],
      'roles' => roles_payload(roles_array)['roles'],
      'bookings' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include BookingPayload, type: :request
end
