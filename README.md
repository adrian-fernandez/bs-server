# README

### Requirements
* Ruby 2.3.4
* Rails 5.1.3

### Setup
* Install gems: `bundle install`
* Check `config/database.yml` file to configure your database connection.
* If you want to use local environment variables you can define them in `.env` file, like `DB_PORT_5432_TCP_ADDR`
Example:
```
DB_PORT_5432_TCP_ADDR=localhost
```
* You can preload DB with sample data: `rake db:seed`
* Now you can run the project: `bin/rails s`

### Sample data
After running `rake db:seed` you will have this data in your DB:
* Users:
  * Superadmin: adrian@adrian-fernandez.net / password
  * Admin admin@adrian-bs.com / password
  * Normal user: user1@adrian-bs.com / password
  * Normal user: user2@adrian-bs.com / password
  * Normal user: user3@adrian-bs.com / password
* 100 random rentals
* 5 random bookings for each rental (from 3 months ago to 2 months in the future).
