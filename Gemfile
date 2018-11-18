source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# The basics
gem 'rails',                    '~> 5.1.5'
ruby                            '~> 2.5.0'

# PostgreSQL database
gem 'pg',                       '~> 1.0.0'

# Use Puma as the app server
gem 'puma',                     '~> 3.11.2'

# Attach remote files to local models
gem 'paperclip',                '~> 6.0.0'
gem 'aws-sdk-s3',               '~> 1.8.2'

# Add simple pagination for result sets
gem 'will_paginate',            '~> 3.1.6'

# User Authentication
gem 'bcrypt',                   '~> 3.1.11'
gem 'devise',                   '~> 4.4.3'
gem 'warden',                   '~> 1.2.7'
gem 'devise_token_auth',        '~> 0.1.43'
gem 'omniauth',                 '~> 1.8.1'
gem 'omniauth-facebook',        '~> 4.0.0'
gem 'omniauth-google-oauth2',   '~> 0.5.3'
gem 'devise-guests',            '~> 0.6.1'


# Location services
gem 'activerecord-postgis-adapter', '~> 5.2.1'
gem 'geocoder',                 '~> 1.4.7'

# JSON APIs views
gem 'jbuilder',                 '~> 2.7.0'

# Generate price range histogram
gem 'histogram',                '~> 0.2.4.1'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors',                '~> 1.0.2'

# Add health checks for scaling
gem 'health_check',             '~> 3.0.0'

# Add role support
gem 'cancancan',                '~> 2.2.0'
gem 'rolify',                   '~> 5.2.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.7.2'
  gem 'dotenv-rails', '~> 2.2.1'
  gem 'rspec_api_documentation'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'rspec_junit_formatter'
end
