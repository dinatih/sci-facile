# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Ensures that the test database schema matches the current schema file.
# If there are pending migrations it will invoke `db:test:prepare` to
# recreate the test database by loading the schema.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails uses metadata to mix in different behaviours to your tests,
  # for example enabling you to call `get` and `post` in request specs. e.g.:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/8-0/rspec-rails
  #
  # You can also this infer these behaviours automatically by location, e.g.
  # /spec/models would pull in the same behaviour as `type: :model` but this
  # behaviour is considered legacy and will be removed in a future version.
  #
  # To enable this behaviour uncomment the line below.
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Ensure SELENIUM_REMOTE_URL is present in the environment
  selenium_url = ENV["SELENIUM_REMOTE_URL"]
  raise "SELENIUM_REMOTE_URL environment variable is missing. Please set it in your devcontainer configuration." unless selenium_url

  rails_service = ENV["RAILS_SERVICE_NAME"] || "rails-app"
  capybara_port = ENV["CAPYBARA_SERVER_PORT"] || 45678
  Capybara.server_host = "0.0.0.0"
  Capybara.app_host = "http://#{rails_service}:#{capybara_port}"

  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome, options: { browser: :remote, url: selenium_url }
  end

  config.include Devise::Test::IntegrationHelpers, type: :request

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # These hooks automatically start and stop a Rails server for system specs.
  # This is necessary because, when using Selenium in a separate container,
  # Capybara cannot launch the Rails server itself on a fixed host/port.
  # The hooks ensure the server is available for browser-based tests and
  # cleanly shut it down after the test suite finishes.
  config.before(:suite) do
    system_specs_present = RSpec.world.example_groups.any? do |group|
      group.metadata[:type] == :system
    end

    if system_specs_present
      require 'net/http'
      uri = URI("http://localhost:45678")
      server_running = begin
        Net::HTTP.get(uri)
        true
      rescue
        false
      end

      unless server_running
        @rails_server_pid = spawn("bundle exec rails server -b 0.0.0.0 -p 45678 -e test")
        File.write("tmp/rails_test_server.pid", @rails_server_pid)

        puts "Starting Rails server for system specs..."
        until begin
          Net::HTTP.get(uri)
          true
        rescue
          false
        end
          sleep 1
        end
        puts "Rails server is ready."
      else
        puts "Rails server already running on port 45678."
      end
    end
    puts "🔎 You can view system tests graphically via NoVNC at: https://localhost:7900"
  end

  config.after(:suite) do
    if File.exist?("tmp/rails_test_server.pid")
      pid = File.read("tmp/rails_test_server.pid").to_i
      puts "Stopping Rails server..."
      Process.kill("TERM", pid)
      File.delete("tmp/rails_test_server.pid")
    end
  end
end
