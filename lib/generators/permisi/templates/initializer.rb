# frozen_string_literal: true

require "permisi"

Permisi.init do |config|
  # Define which backend to use
  # See https://github.com/ukazap/permisi#configuring-backend
  config.backend = :active_record

  # Define all permissions available in the system
  # See https://github.com/ukazap/permisi#configuring-permissions
  config.permissions = {}

  # Define cache store
  # See https://github.com/ukazap/permisi#caching
  config.cache_store = Rails.cache

  # Uncomment to mute initialization warnings
  # config.mute_warnings = true
end
