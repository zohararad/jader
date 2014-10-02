ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
require 'pry'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "rspec/rails"
require 'rspec/active_model/mocks'

require 'jader'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  require 'rspec/mocks'
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # Enable old-style rspec API
  config.mock_with :rspec  do |c|
    c.syntax = :should
  end
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
  config.infer_spec_type_from_file_location!
end