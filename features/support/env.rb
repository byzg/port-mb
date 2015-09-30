require 'capybara/poltergeist'
require 'webmock/cucumber'
# require 'cucumber/rspec/doubles'
# require_relative './helpers'
AWS.stub!
WebMock.disable_net_connect!(allow_localhost: true)

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../../config/environment", __FILE__)
require 'cucumber/rails'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
      debug: false,
      inspector: false,
      phantomjs_options: ['--ignore-ssl-errors=yes'],
      js_errors: true
  })
end
if ENV["SHOWME"]
  Capybara.javascript_driver = :selenium
else
  Capybara.javascript_driver = :poltergeist
end

# ActionController::Base.allow_rescue = false
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

# After dogem 'mocha', :require => false
#   gem 'webmock'
#   FactoryGirl.reload
# end