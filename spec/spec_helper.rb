# frozen_string_literal: true

require_relative "../spec/dummy/config/environment"
require "bundler/setup"
Bundler.setup

require "rspec/rails"
require "pry"

require "helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  include Helpers

  config.before(:suite) do
    install_engine
  end

  config.after(:suite) do
    uninstall_engine
  end
end
