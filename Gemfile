source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts_as_tenant'
gem 'activeadmin', github: 'activeadmin'
gem 'active_model_serializers', '~> 0.9.3'
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'coffee-rails', '~> 4.2'
gem 'dotenv-rails', '~> 2.0.1'
gem 'email_validator', '1.4.0'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.0.4'
gem 'hashie'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'mini_portile', '0.5.3'
gem 'newrelic_rpm'
gem 'nokogiri', '1.6'
gem 'paper_trail'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.3'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 1.3.0'
gem 'sqlite3'
gem 'textacular', '~> 5.0.1'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'validates_timeliness', '~> 4.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'i18n-tasks'
  gem 'rspec-rails'
  gem 'timecop'
end

group :test do
  gem 'hashdiff'
  gem 'json-schema'
  gem 'shoulda-matchers', '3.1.1', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'letter_opener'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'
  gem 'web-console', '>= 3.3.0'
end
