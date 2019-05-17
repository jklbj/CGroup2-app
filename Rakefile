# frozen_string_literal: true

require 'rake/testtask'

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
  sh 'pry -r ./specs/test_load_all'
end

desc 'Rake all the Ruby'
task :style do
  `rubocop .`
end

desc 'Test all the specs'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'specs/**/*_spec.rb'
  t.warning = false
end

namespace :run do
  # Run in development mode
  task :dev do
    sh 'rackup -p 9293'
  end
end

namespace :session do
  desc 'Wipe all sessions stored in Redis'
  task :wipe => :load_lib do
    require 'redis'
    puts 'Deleting all sessions from Redis session store'
    wiped = SecureSession.wipe_redis_sessions
    puts "#{wiped.count} sessions deleted"
  end
end
