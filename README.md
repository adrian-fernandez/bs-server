# README

### Requirements
* Ruby 2.3.4
* Rails 5.1.3

### Setup
* Install gems: `bundle install`
* Check `config/database.yml` file to configure your database connection.
* If you want to use local environment variables you can define them in `.env` file, like `DB_PORT_5432_TCP_ADDR`
* You can preload DB with sample data: `rake db:seed`
* Now you can run the project: `bin/rails s`
