ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
I18n.locale = 'ru'
RSpec.configure do |config|
  config.mock_framework = :rspec
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    WebMock.reset!
  end
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
  config.fail_fast = true
end