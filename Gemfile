# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.2'

# Web
gem 'puma'
gem 'roda'
gem 'slim'

# Configuration
gem 'econfig'
gem 'rake'

# Security
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

# Communication
gem 'http'
gem 'redis'
gem 'redis-rack'

# Debugging
gem 'pry'
gem 'rack-test'

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'webmock'
end

<<<<<<< HEAD
group :development, :test do
  gem 'rerun'
end

=======
>>>>>>> 7acb024d7355c13b61b02dc6aedbe756c4124b4c
group :production do 
  gem 'rerun'
end