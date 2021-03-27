require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GeyserList
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.integrations = config_for(:integrations)

    Sentry.init do |sentry_config|
      sentry_config.dsn = credentials.dig(:sentry_dsn)
        sentry_config.breadcrumbs_logger = [:active_support_logger]
      sentry_config.environment = Rails.env

      # To activate performance monitoring, set one of these options.
      # We recommend adjusting the value in production:
      sentry_config.traces_sample_rate = 0.5
      # or
      sentry_config.traces_sampler = lambda do |context|
        true
      end
    end if Rails.env == "production" # Only log in production
  end
end
