source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'hashie'

# ActiveAdmin
gem 'devise'
gem 'activeadmin'

gem 'faraday'
gem 'dotenv-rails'
gem 'rack-cors'
gem 'rack-attack'
gem 'redis-rails'
gem "sentry-raven"

group :development, :test do
  gem 'annotate'
  gem 'rails-erd'

  gem 'pry'
  gem 'overcommit'
  gem 'rubocop'
  gem 'fasterer'
  gem 'rails_best_practices'
  gem 'brakeman'

  gem "rspec-rails", "~> 3.5"
  gem "database_cleaner"
  gem "faker"
  gem "shoulda-matchers", "~> 3.1"
  gem "factory_bot_rails", "~> 4.0"
  gem "timecop"
  gem "webmock"
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
