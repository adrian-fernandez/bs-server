# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

client = Client.create(name: 'sample client')
ActsAsTenant.current_tenant = client

superadmin_role = Role.create!(name: 'superadmin', client: client)
admin_role = Role.create(name: 'admin', client: client)
user_role = Role.create(name: 'user', client: client)

User.create(
  email: 'adrian@adrian-fernandez.net',
  password: 'password',
  password_confirmation: 'password',
  roles: [admin_role],
  client: client
)

User.create(
  email: 'admin@adrian-bs.com',
  password: 'password',
  password_confirmation: 'password',
  roles: [admin_role],
  client: client
)

users = [
  User.create(
    email: 'user1@adrian-bs.com',
    password: 'password',
    password_confirmation: 'password',
    roles: [user_role],
    client: client
  ),

  User.create(
    email: 'user2@adrian-bs.com',
    password: 'password',
    password_confirmation: 'password',
    roles: [user_role],
    client: client
  ),

  User.create(
    email: 'user3@adrian-bs.com',
    password: 'password',
    password_confirmation: 'password',
    roles: [user_role],
    client: client
  )
]

rentals = []
100.times do
  rentals << Rental.create(
    user: users[Faker::Number.between(0, 2)],
    name: Faker::Company.name,
    daily_rate: Faker::Number.decimal(2, 2),
    client: client
  )

  5.times do
    available_users = users.select { |x| x unless x == rentals.last.user }
    from_date = Faker::Date.between(3.months.ago, Date.today + 2.months)
    to_date = Faker::Date.between(from_date + 1.day, from_date + 2.weeks)

    Booking.create(
      rental: rentals.last,
      start_at: from_date,
      end_at: to_date,
      user: available_users[Faker::Number.between(0, 1)],
      client: client
    )
  end
end
