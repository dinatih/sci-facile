require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SciFacile
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.default_locale = :fr
    config.time_zone = "Europe/Paris"

    config.generators do |g|
      g.request_specs false
      g.routing_specs false
      g.helper_specs false
      g.view_specs false
    end

    config.hosts << /\Arails-app:\d+\z/

    config.hosts << /.*\.ngrok\.io/
    config.hosts << /.*\.ngrok-free\.app/

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: "gmail.com",
      user_name: Rails.application.credentials.gmail[:username],
      password: Rails.application.credentials.gmail[:password],
      authentication: "plain",
      enable_starttls_auto: true
    }

    config.action_mailer.default_options = {
      from: "sci.facile.saas@gmail.com"
    }
  end
end
