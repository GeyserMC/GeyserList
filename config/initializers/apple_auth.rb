# frozen_string_literal: true

AppleAuth.configure do |config|
  config.apple_client_id = Rails.application.credentials.apple[:client_id]
  config.apple_private_key = Rails.application.credentials.apple[:private_key]
  config.apple_key_id = Rails.application.credentials.apple[:key_id]
  config.apple_team_id = Rails.application.credentials.apple[:team_id]
  # config.redirect_uri = <Your app redirect url>
end
