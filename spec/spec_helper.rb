# frozen_string_literal: true

require_relative "../spec/dummy/config/environment"
require "bundler/setup"
Bundler.setup

require "rspec/rails"
require "pry"

require "helpers"

Dir["lib/generators/templates/render_content.thor"].sort.each { |f| load f }

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

  render_options = {
    :subdirectory => "",
    :layout => ::MarkdownRecord.config.concatenated_layout_path,
    :save => true,
    :strat => :full
  }

  config.before(:all, :render => true) do
    ::RenderContent.new.invoke(:all, [], render_options)
  end

  config.after(:all, :render => true) do
    remove_rendered_content
  end
end
