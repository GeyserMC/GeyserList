Sentry.init do |sentry_config|
  sentry_config.dsn = Rails.application.credentials.dig(:sentry_dsn)
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